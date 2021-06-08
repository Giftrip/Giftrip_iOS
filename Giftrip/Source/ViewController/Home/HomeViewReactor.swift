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

final class HomeViewReactor: Reactor, Stepper {

    var steps = PublishRelay<Step>()

    enum Action {
        case selectSpot(Int)
    }

    enum Mutation {
        case setLoading(Bool)
    }

    struct State {
        var spotListViewReactor: SpotListViewReactor
        var isLoading: Bool = false
    }

    let initialState: State
    let spotService: SpotServiceType

    init(
        spotService: SpotServiceType
    ) {
        self.spotService = spotService
        
        self.initialState = State(spotListViewReactor: SpotListViewReactor(spotService: spotService))
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .selectSpot(spotIdx):
            self.steps.accept(GiftripStep.spotDetailIsRequired(idx: spotIdx))
            return .empty()
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state

        switch mutation {
        case let .setLoading(isLoading):
            state.isLoading = isLoading
        }

        return state
    }

}
