//
//  PrivacyPolicyViewReactor.swift
//  Giftrip
//
//  Created by 강민석 on 2021/05/06.
//

import ReactorKit
import RxCocoa
import RxSwift
import RxFlow

final class PrivacyPolicyViewReactor: Reactor, Stepper {
    var steps = PublishRelay<Step>()
    typealias Action = NoAction
    struct State {}
    let initialState: State = State()
}

//final class PrivacyPolicyViewReactor: Reactor, Stepper {
//
//    var steps = PublishRelay<Step>()
//
//    enum Action {
//
//    }
//
//    enum Mutation {
//
//    }
//
//    struct State {
//
//    }
//
//    let initialState: State
//
//    init() {
//
//    }
//
//    func mutate(action: Action) -> Observable<Mutation> {
//        switch action {
//        case <#pattern#>:
//            <#code#>
//        }
//    }
//
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
//
//}
