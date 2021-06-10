//
//  HomeFlow.swift
//  Giftrip
//
//  Created by 강민석 on 2021/05/06.
//

import RxFlow

final class HomeFlow: Flow {
    
    private let services: AppServices
    
    var root: Presentable {
        return self.rootViewController
    }
    
    let rootViewController = UINavigationController().then {
        $0.isNavigationBarHidden = true
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
        case .homeIsRequired:
            return self.navigateToHome()
        default:
            return .none
        }
    }
}

extension HomeFlow {
    private func navigateToHome() -> FlowContributors {
        let reactor = HomeViewReactor(spotService: services.spotService)
        let viewController = HomeViewController(reactor: reactor)
        
        self.rootViewController.pushViewController(viewController, animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
}
