//
//  LoginViewReactor.swift
//  Giftrip
//
//  Created by 강민석 on 2021/05/06.
//

import ReactorKit
import RxCocoa
import RxSwift
import RxFlow
import SwiftMessages

final class LoginViewReactor: Reactor, Stepper {

    var steps = PublishRelay<Step>()

    enum Action {
        case validPhone(String)
        case validPassword(String)
        case login
    }

    enum Mutation {
        case checkPhone(String)
        case checkPassword(String)
        case setLoading(Bool)
    }

    struct State {
        var phoneNumber: String = ""
        var password: String = ""
        
        var isLoading: Bool = false
        
        var phoneValidation: Bool = false
        var passwordValidation: Bool = false
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
        case .login:
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                
                self.authService.login(self.currentState.phoneNumber, self.currentState.password)
                    .asObservable()
                    .flatMap { self.userService.fetchUser() }
                    .map { true }.catchErrorJustReturn(false)
                    .do { isLoggedIn in
                        if isLoggedIn {
                            SwiftMessages.show(config: Message.bottomConfig, view: Message.successView("로그인 성공"))
                            self.steps.accept(GiftripStep.mainTabBarIsRequired)
                        } else {
                            SwiftMessages.show(config: Message.bottomConfig, view: Message.faildView("로그인 실패"))
                        }
                    }.flatMap { _ in Observable.empty() },
                
                Observable.just(Mutation.setLoading(false))
            ])
            
        case let .validPhone(phone):
            return Observable.just(Mutation.checkPhone(phone))
            
        case let .validPassword(password):
            return Observable.just(Mutation.checkPassword(password))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state

        switch mutation {
        case let .setLoading(isLoading):
            state.isLoading = isLoading
        
        case let .checkPhone(phone):
            state.phoneNumber = phone
            state.phoneValidation = phone.isPhone
            
        case let .checkPassword(password):
            state.password = password
            state.passwordValidation = password.isNotEmpty
        }

        return state
    }
}
