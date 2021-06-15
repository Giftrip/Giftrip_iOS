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
    }
    
    enum Mutation {
        
    }
    
    struct State {
        let title: String
        let address: String
        let description: String
        let images: [URL]
    }
    
    let initialState: State
    let spot: Spot
    
    init(spot: Spot) {
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
        }
    }

//    func reduce(state: State, mutation: Mutation) -> State {
//        var state = state
//
//        switch mutation {
//        case <#pattern#>:
//            <#code#>
//        }
//
//        return state
//    }
    
}
