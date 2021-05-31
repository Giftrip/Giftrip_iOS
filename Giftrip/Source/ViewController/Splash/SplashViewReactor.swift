//
//  SplashViewReactor.swift
//  Giftrip
//
//  Created by 강민석 on 2021/05/06.
//

import ReactorKit
import RxCocoa
import RxSwift
import RxFlow

final class SplashViewReactor: Reactor, Stepper {

    var steps = PublishRelay<Step>()

    enum Action {
        case branchView
    }

    enum Mutation {
        
    }

    struct State {
        
    }

    let initialState: State = State()
    fileprivate let authService: AuthServiceType
    fileprivate let userService: UserServiceType
    
    let errorRelay = PublishRelay<Error>()

    init(
        authService: AuthServiceType,
        userService: UserServiceType
    ) {
        self.authService = authService
        self.userService = userService
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .branchView:
            if self.authService.currentToken == nil {
                self.steps.accept(GiftripStep.introIsRequired)
                return Observable.empty()
            }
            
            return self.userService.fetchUser()
                .asObservable()
                .do(onNext: {
                    self.steps.accept(GiftripStep.mainTabBarIsRequired)
                }, onError: { error in
                    self.steps.accept(GiftripStep.introIsRequired)
                    self.errorRelay.accept(error)
                }).flatMap { _ in Observable.empty() }
        }
    }
}
