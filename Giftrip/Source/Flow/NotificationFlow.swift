//
//  NotificationFlow.swift
//  Giftrip
//
//  Created by 강민석 on 2021/05/06.
//

import RxFlow

final class NotificationFlow: Flow {
    
    private let services: AppServices
    
    var root: Presentable {
        return self.rootViewController
    }
    
    private lazy var rootViewController = UINavigationController().then {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = UIColor.systemGroupedBackground
        navigationBarAppearance.shadowColor = nil
        $0.navigationBar.standardAppearance = navigationBarAppearance
    }
    
    init(services: AppServices) {
        self.services = services
    }
    
    deinit {
        print("❎ \(type(of: self)): \(#function)")
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? GiftripStep else { return .none }
        
        switch step {
        case .notificationIsRequired:
            return self.navigateToNotification()
            
        case let .notificationDetailIsRequired(idx):
            return self.navigateToNotificationDetail(idx: idx)
            
        default:
            return .none
        }
    }
}

extension NotificationFlow {
    private func navigateToNotification() -> FlowContributors {
        let reactor = NotificationViewReactor(noticeService: self.services.noticeService)
        let viewController = NotificationViewController(reactor: reactor)
        
        self.rootViewController.pushViewController(viewController, animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToNotificationDetail(idx: Int) -> FlowContributors {
        let reactor = NotificationDetailViewReactor(noticeService: self.services.noticeService, idx: idx)
        let viewController = NotificationDetailViewController(reactor: reactor)
        
        self.rootViewController.pushViewController(viewController, animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
}
