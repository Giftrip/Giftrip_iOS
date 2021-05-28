//
//  AppFlow.swift
//  Giftrip
//
//  Created by 강민석 on 2021/05/06.
//

import UIKit
import RxFlow
import RxSwift
import RxCocoa

final class AppFlow: Flow {
    
    private let window: UIWindow
    private let services: AppServices
    
    var root: Presentable {
        return self.window
    }
    
    init(window: UIWindow, services: AppServices) {
        self.window = window
        self.services = services
    }
    
    deinit {
        print("❎ \(type(of: self)): \(#function)")
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? GiftripStep else { return .none }
        
        switch step {
        case .splashIsRequired:
            return navigateToSplash()
            
        case .introIsRequired:
            return navigateToIntro()
            
        case .mainTabBarIsRequired:
            return navigateToTabBar()
            
        default:
            return .none
        }
    }
}

extension AppFlow {
    private func navigateToSplash() -> FlowContributors {
        let reactor = SplashViewReactor(authService: self.services.authService, userService: self.services.userService)
        let viewController = SplashViewController(reactor: reactor)
        
        self.window.rootViewController = viewController
        
        UIView.transition(with: self.window,
                          duration: 0.3,
                          options: [.transitionCrossDissolve],
                          animations: nil,
                          completion: nil)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToIntro() -> FlowContributors {
        let introFlow = IntroFlow(services)
        
        Flows.use(introFlow, when: .created) { [unowned self] root in
            self.window.rootViewController = root
            
            UIView.transition(with: self.window,
                              duration: 0.3,
                              options: [.transitionCrossDissolve],
                              animations: nil,
                              completion: nil)
        }
        
        let nextStep = OneStepper(withSingleStep: GiftripStep.introIsRequired)
        return .one(flowContributor: .contribute(withNextPresentable: introFlow, withNextStepper: nextStep))
    }
    
    private func navigateToTabBar() -> FlowContributors {
        let tabBarFlow = TabBarFlow()
        
        Flows.use(tabBarFlow, when: .created) { [unowned self] root in
            self.window.rootViewController = root
            
            UIView.transition(with: self.window,
                              duration: 0.3,
                              options: [.transitionCrossDissolve],
                              animations: nil,
                              completion: nil)
        }
        
        let nextStep = OneStepper(withSingleStep: GiftripStep.mainTabBarIsRequired)
        return .one(flowContributor: .contribute(withNextPresentable: tabBarFlow, withNextStepper: nextStep))
    }
}
