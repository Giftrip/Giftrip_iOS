//
//  NotificationFlow.swift
//  Giftrip
//
//  Created by 강민석 on 2021/05/06.
//

import RxFlow

final class NotificationFlow: Flow {
    
    var root: Presentable {
        return self.rootViewController
    }
    
    let rootViewController: UINavigationController
    
    init() {
        self.rootViewController = UINavigationController()
    }
    
    deinit {
        print("❎ \(type(of: self)): \(#function)")
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? GiftripStep else { return .none }
        
        switch step {
        case .notificationIsRequired:
            return self.navigateToNotification()
        default:
            return .none
        }
    }
}

extension NotificationFlow {
    private func navigateToNotification() -> FlowContributors {
        return .none
    }
}