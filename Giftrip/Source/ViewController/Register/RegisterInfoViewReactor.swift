//
//  RegisterInfoViewReactor.swift
//  Giftrip
//
//  Created by 강민석 on 2021/05/06.
//

import ReactorKit
import RxCocoa
import RxSwift
import RxFlow

final class RegisterInfoViewReactor: Reactor, Stepper {

    var steps = PublishRelay<Step>()

    enum Action {
        case setName(String)
        case setBirthDate(Date)
        case next
    }

    enum Mutation {
        case validName(String)
        case setBirthDate(Date)
    }

    struct State {
        var name: String = ""
        var birthDate: Date = Date()
        
        var nameValidation: Bool = false
        var birthDateValidation: Bool = false
    }

    let initialState: State = State()

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .setBirthDate(birthDate):
            return Observable.just(Mutation.setBirthDate(birthDate))
            
        case let .setName(name):
            return Observable.just(Mutation.validName(name))
            
        case .next:
            self.steps.accept(GiftripStep.registerPhoneIsRequired(name: self.currentState.name, birth: self.currentState.birthDate))
            return .empty()
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state

        switch mutation {
        case let .setBirthDate(birthDate):
            state.birthDate = birthDate
            state.birthDateValidation = true
            
        case let .validName(name):
            state.name = name
            state.nameValidation = name.isName
        }

        return state
    }

}
