//
//  TabBarFlow.swift
//  Giftrip
//
//  Created by 강민석 on 2021/05/06.
//

import UIKit
import RxFlow

final class TabBarFlow: Flow {
    
    private var rootViewController: UITabBarController
    
    private let services: AppServices
    
    var root: Presentable {
        return rootViewController
    }
    
    init(_ services: AppServices) {
        self.rootViewController = TabBarViewController()
        self.services = services
    }
    
    deinit {
        print("❎ \(type(of: self)): \(#function)")
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? GiftripStep else { return .none }
        
        switch step {
        case .mainTabBarIsRequired:
            return navigateToTabBar()
            
        default:
            return .none
        }
    }
}

extension TabBarFlow {
    private func navigateToTabBar() -> FlowContributors {
        let homeFlow = HomeFlow(services: services)
        let rankFlow = RankFlow()
        let giftFlow = GiftFlow()
        let notificationFlow = NotificationFlow()
        let settingsFlow = SettingsFlow()
        
        Flows.use(homeFlow,
                  rankFlow,
                  giftFlow,
                  notificationFlow,
                  settingsFlow,
                  when: .created) { [unowned self] (root1, root2, root3, root4, root5: UINavigationController) in
            let tabBarItem1 = UITabBarItem(title: nil, image: R.image.home(), selectedImage: nil)
            root1.tabBarItem = tabBarItem1
            
            let tabBarItem2 = UITabBarItem(title: nil, image: R.image.flag(), selectedImage: nil)
            root2.tabBarItem = tabBarItem2
            
            let tabBarItem3 = UITabBarItem(title: nil, image: R.image.gift(), selectedImage: nil)
            root3.tabBarItem = tabBarItem3
            
            let tabBarItem4 = UITabBarItem(title: nil, image: R.image.bell(), selectedImage: nil)
            root4.tabBarItem = tabBarItem4
            
            let tabBarItem5 = UITabBarItem(title: nil, image: R.image.gear(), selectedImage: nil)
            root5.tabBarItem = tabBarItem5
            
            self.rootViewController.setViewControllers([root1, root2, root3, root4, root5], animated: false)
        }
        
        return .multiple(flowContributors: [
            .contribute(withNextPresentable: homeFlow,
                        withNextStepper: OneStepper(withSingleStep: GiftripStep.homeIsRequired)),
            
            .contribute(withNextPresentable: rankFlow,
                        withNextStepper: OneStepper(withSingleStep: GiftripStep.rankIsRequired)),
            
            .contribute(withNextPresentable: giftFlow,
                        withNextStepper: OneStepper(withSingleStep: GiftripStep.giftIsRequired)),
            
            .contribute(withNextPresentable: notificationFlow,
                        withNextStepper: OneStepper(withSingleStep: GiftripStep.notificationIsRequired)),
            
            .contribute(withNextPresentable: settingsFlow,
                        withNextStepper: OneStepper(withSingleStep: GiftripStep.settingsIsRequired))
        ])
    }
}
