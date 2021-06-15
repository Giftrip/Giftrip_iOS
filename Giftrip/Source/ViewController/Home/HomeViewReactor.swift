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
        case selectSpot(Int)
        case setLocation(Spot)
    }

    enum Mutation {
        case setLoading(Bool)
        case setLocation(Spot)
    }

    struct State {
        var spotListViewReactor: SpotListViewReactor
        var isLoading: Bool = false
        
        var currentLocation: Spot?
    }

    let initialState: State
    let spotService: SpotServiceType

    init(
        spotService: SpotServiceType
    ) {
        self.spotService = spotService
        
        self.initialState = State(spotListViewReactor: SpotListViewReactor(spotService: spotService))
    }
    
    func transform(action: Observable<Action>) -> Observable<Action> {
        return Observable.merge(action, setLocation.map(Action.setLocation))
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .selectSpot(spotIdx):
            self.steps.accept(GiftripStep.spotDetailIsRequired(idx: spotIdx))
            return .empty()
            
        case let .setLocation(spot):
            return Observable.just(Mutation.setLocation(spot))
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
