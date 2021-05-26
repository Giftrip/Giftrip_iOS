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
        case validPhoneNumber(String)
        case next
    }

    enum Mutation {
        case setPhoneNumber(String)
        case setAuthCodeResponse(AuthCodeResponse)
        case setError(Error)
    }

    struct State {
        var phoneNumber: String = ""
        
        var phoneNumberValidation: Bool = false
        
        var authCodeResponse: AuthCodeResponse?
        var error: ErrorResponse?
    }

    let initialState: State = State()
    
    fileprivate let authService: AuthServiceType
    
    init(authService: AuthServiceType) {
        self.authService = authService
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .validPhoneNumber(phoneNumber):
            return Observable.just(Mutation.setPhoneNumber(phoneNumber))
            
        case .next:
            return self.authService.createAuthCode(self.currentState.phoneNumber)
                .asObservable()
                .map { response in
                    Mutation.setAuthCodeResponse(response)
                }
                .catchError { error in
                    return .just(Mutation.setError(error))
                }
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state

        switch mutation {
        case let .setPhoneNumber(phoneNumber):
            state.phoneNumber = phoneNumber
            state.phoneNumberValidation = phoneNumber.isPhone
            
        case let .setAuthCodeResponse(authCodeResponse):
            state.authCodeResponse = authCodeResponse
            
        case let .setError(error):
            if let error = error as? ErrorResponse {
                state.error = error
            }
        }

        return state
    }
}
