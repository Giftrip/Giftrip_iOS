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

    }

    enum Mutation {

    }

    struct State {
        let spotListViewReactor: SpotListViewReactor
    }

    let initialState: State
    fileprivate let 

    init() {
        
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case <#pattern#>:
            <#code#>
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state

        switch mutation {
        case <#pattern#>:
            <#code#>
        }

        return state
    }

}
