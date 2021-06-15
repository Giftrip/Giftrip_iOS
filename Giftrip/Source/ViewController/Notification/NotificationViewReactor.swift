//
//  NotificationViewReactor.swift
//  Giftrip
//
//  Created by 강민석 on 2021/06/15.
//

import ReactorKit
import RxCocoa
import RxSwift
import RxFlow

final class NotificationViewReactor: Reactor, Stepper {

    var steps = PublishRelay<Step>()

    enum Action {

    }

    enum Mutation {

    }

    struct State {

    }

    let initialState: State = State()
    private let noticeService: NoticeServiceType

    init(noticeService: NoticeServiceType) {
        self.noticeService = noticeService
    }

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

}
