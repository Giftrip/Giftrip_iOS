//
//  RegisterPhoneViewReactor.swift
//  Giftrip
//
//  Created by 강민석 on 2021/05/06.
//

import ReactorKit
import RxCocoa
import RxSwift
import RxFlow
import SwiftMessages

final class RegisterPhoneViewReactor: Reactor, Stepper {
    
    var steps = PublishRelay<Step>()
    
    enum Action {
        case setPhoneNumber(String)
        case setPassword(String)
        case next
    }
    
    enum Mutation {
        case validPhoneNumber(String)
        case validPassword(String)
        case setAuthCodeResponse(AuthCodeResponse)
        case setError(Error)
        case setLoading(Bool)
    }
    
    struct State {
        var phoneNumber: String = ""
        var password: String = ""
        
        var phoneNumberValidation: Bool = false
        var passwordValidation: Bool = false
        
        var authCodeResponse: AuthCodeResponse?
        var error: ErrorResponse?
        
        var isLoading: Bool = false
    }
    
    let initialState: State = State()
    
    fileprivate let authService: AuthServiceType
    
    init(authService: AuthServiceType) {
        self.authService = authService
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .setPhoneNumber(phoneNumber):
            return Observable.just(Mutation.validPhoneNumber(phoneNumber))
            
        case let .setPassword(password):
            return Observable.just(Mutation.validPassword(password))
            
        case .next:
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                
                self.authService.createAuthCode(self.currentState.phoneNumber)
                .asObservable()
                .map { response in
                    self.steps.accept(GiftripStep.registerAuthCodeIsRequired(phone: self.currentState.phoneNumber, password: self.currentState.password))
                    return Mutation.setAuthCodeResponse(response)
                }
                .catchError { error in
                    return .just(Mutation.setError(error))
                },
                
                Observable.just(Mutation.setLoading(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case let .validPhoneNumber(phoneNumber):
            state.phoneNumber = phoneNumber
            state.phoneNumberValidation = phoneNumber.isPhone
            
        case let .validPassword(password):
            state.password = password
            state.passwordValidation = password.isNotEmpty
            
        case let .setAuthCodeResponse(authCodeResponse):
            state.authCodeResponse = authCodeResponse
            
        case let .setError(error):
            if let error = error as? ErrorResponse {
                state.error = error
            }
            
        case let .setLoading(isLoading):
            state.isLoading = isLoading
        }
        
        return state
    }
}
