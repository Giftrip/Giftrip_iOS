//
//  SpotDetailViewReactor.swift
//  Giftrip
//
//  Created by 강민석 on 2021/06/15.
//

import ReactorKit
import RxCocoa
import RxSwift
import RxFlow

final class SpotDetailViewReactor: Reactor, Stepper {
    var steps = PublishRelay<Step>()
    
    enum Action {
        case moveToMap
        case nfcTagRead(String)
        
        case showYouTube
        case showQuiz
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setError(Error)
        case showAlert(Quiz, String)
    }
    
    struct State {
        let title: String
        let address: String
        let description: String
        let images: [URL]
        
        var isLoading: Bool = false
        var error: ErrorResponse?
        
        var quiz: String = ""
        var youtube: URL?
        var nfcCode: String = ""
    }
    
    let initialState: State
    private let spotService: SpotServiceType
    let spot: Spot
    
    let alertTrigger = PublishSubject<Void>()
    
    init(spotService: SpotServiceType, spot: Spot) {
        self.spotService = spotService
        self.spot = spot
        
        self.initialState = State(
            title: spot.title,
            address: spot.address,
            description: spot.description,
            images: spot.thumbnails
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .moveToMap:
            setLocation.onNext(self.spot)
            self.steps.accept(GiftripStep.popViewController)
            return .empty()
            
        case let .nfcTagRead(nfcCode):
            let startLoading = Observable.just(Mutation.setLoading(true))
            let stopLoading = Observable.just(Mutation.setLoading(false))
            
            let getQuiz = self.spotService.getQuizByNfc(self.spot.idx, nfcCode)
                .asObservable()
                .map { response in
                    return Mutation.showAlert(response, nfcCode)
                }
                .catchError { error in
                    return .just(Mutation.setError(error))
                }
            
            return Observable.concat([startLoading, getQuiz, stopLoading])
            
        case .showYouTube:
            guard let url = self.currentState.youtube else { return .empty() }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            self.steps.accept(GiftripStep.quizIsRequired(quiz: self.currentState.quiz, nfcCode: self.currentState.nfcCode))
            return .empty()
            
        case .showQuiz:
            self.steps.accept(GiftripStep.quizIsRequired(quiz: self.currentState.quiz, nfcCode: self.currentState.nfcCode))
            return .empty()
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state

        switch mutation {
        case let .setLoading(isLoading):
            state.isLoading = isLoading
            
        case let .showAlert(quiz, nfcCode):
            state.quiz = quiz.quiz
            state.youtube = quiz.youtube
            state.nfcCode = nfcCode
            self.alertTrigger.onNext(())
            
        case let .setError(error):
            if let error = error as? ErrorResponse {
                state.error = error
            }
        }

        return state
    }
}
