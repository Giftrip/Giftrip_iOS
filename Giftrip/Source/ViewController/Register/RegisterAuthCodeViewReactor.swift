//
//  RegisterAuthCodeViewReactor.swift
//  Giftrip
//
//  Created by 강민석 on 2021/05/27.
//

import ReactorKit
import RxCocoa
import RxSwift
import RxFlow

final class RegisterAuthCodeViewReactor: Reactor, Stepper {
    
    var steps = PublishRelay<Step>()
    
    enum Action {
        case register
        case setAuthCode(String)
    }
    
    enum Mutation {
        case validAuthCode(String)
        case setError(Error)
        case setLoading(Bool)
        case setSuccess(String)
    }
    
    struct State {
        let name: String
        let birth: Date
        let phone: String
        let password: String
        
        var authCode: String = ""
        var authCodeValidation: Bool = false
        
        var error: ErrorResponse?
        var successMessage: String?
        var isLoading: Bool = false
    }
    
    let initialState: State
    
    private let authService: AuthServiceType
    private let userService: UserServiceType
    
    init(
        authService: AuthServiceType,
        userService: UserServiceType,
        name: String,
        birth: Date,
        phone: String,
        password: String
    ) {
        self.authService = authService
        self.userService = userService
        self.initialState = State(
            name: name,
            birth: birth,
            phone: phone,
            password: password
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .register:
            let state = self.currentState
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                self.authService.register(state.phone, state.authCode, state.password, state.name, state.birth)
                    .flatMap { self.userService.fetchUser() }
                    .map {
                        self.steps.accept(GiftripStep.mainTabBarIsRequired)
                        return Mutation.setSuccess("회원가입 성공")
                    }.catchError { error in
                        return .just(Mutation.setError(error))
                    },
                Observable.just(Mutation.setLoading(false))
            ])
            
        case let .setAuthCode(authCode):
            return Observable.just(Mutation.validAuthCode(authCode))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case let .validAuthCode(authCode):
            state.authCode = authCode
            state.authCodeValidation = authCode.isNotEmpty
            
        case let .setError(error):
            if let error = error as? ErrorResponse {
                state.error = error
            }
            
        case let .setSuccess(message):
            state.successMessage = message
            
        case let .setLoading(isLoading):
            state.isLoading = isLoading
        }
        
        return state
    }
}
