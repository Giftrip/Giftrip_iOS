//
//  IntroViewReactor.swift
//  Giftrip
//
//  Created by 강민석 on 2021/05/06.
//

import ReactorKit
import RxCocoa
import RxSwift
import RxFlow

final class IntroViewReactor: Reactor, Stepper {
    
    var steps = PublishRelay<Step>()
    
    enum Action {
        case login
        case register
        case privacyPolicy
    }
    
    enum Mutation { }
    
    struct State { }
    
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .login:
            self.steps.accept(GiftripStep.loginIsRequired)
            return .empty()
            
        case .register:
            self.steps.accept(GiftripStep.registerInfoIsRequired)
            return .empty()
            
        case .privacyPolicy:
            self.steps.accept(GiftripStep.privacyPolicyIsRequired)
            return .empty()
        }
    }
}
