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
        case setError(Error)
    }

    struct State {
        var error: ErrorResponse?
    }

    let initialState: State = State()
    fileprivate let authService: AuthServiceType
    fileprivate let userService: UserServiceType

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
                .map { true }
                .catchErrorJustReturn(false)
                .do { isLoggedIn in
                    if isLoggedIn {
                        self.steps.accept(GiftripStep.mainTabBarIsRequired)
                    } else {
                        self.steps.accept(GiftripStep.introIsRequired)
                    }
                }.flatMap { _ in Observable.empty() }
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state

        switch mutation {
        case let .setError(error):
            if let error = error as? ErrorResponse {
                state.error = error
            }
        }

        return state
    }
}
