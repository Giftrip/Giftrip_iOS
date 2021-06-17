//
//  HomeViewReactor.swift
//  Giftrip
//
//  Created by 강민석 on 2021/05/31.
//

import ReactorKit
import RxCocoa
import RxSwift
import RxFlow

let setLocation = PublishSubject<Spot>()

final class HomeViewReactor: Reactor, Stepper {

    var steps = PublishRelay<Step>()

    enum Action {
        case selectSpot(Spot)
        case setLocation(Spot)
        case presentCourseList
    }

    enum Mutation {
        case setLoading(Bool)
        case setLocation(Spot)
    }

    struct State {
        var isLoading: Bool = false
        
        var currentLocation: Spot?
    }

    let initialState: State = State()
    let spotService: SpotServiceType
    let spotListViewReactor: SpotListViewReactor

    init(
        spotService: SpotServiceType
    ) {
        self.spotService = spotService
        
        self.spotListViewReactor = SpotListViewReactor(spotService: self.spotService, steps: self.steps)
    }
    
    func transform(action: Observable<Action>) -> Observable<Action> {
        return Observable.merge(action, setLocation.map(Action.setLocation))
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .selectSpot(spot):
            self.steps.accept(GiftripStep.spotDetailIsRequired(spot: spot))
            return .empty()
            
        case let .setLocation(spot):
            return Observable.just(Mutation.setLocation(spot))
            
        case .presentCourseList:
            self.steps.accept(GiftripStep.courseListIsRequired)
            return .empty()
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state

        switch mutation {
        case let .setLoading(isLoading):
            state.isLoading = isLoading
            
        case let .setLocation(spot):
            state.currentLocation = spot
        }

        return state
    }

}
