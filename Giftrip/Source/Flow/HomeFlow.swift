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
    
    private lazy var rootViewController = UINavigationController().then {
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
            
        case let .spotDetailIsRequired(spot):
            return self.navigateToSpotDetail(spot: spot)
            
        case .courseListIsrequired:
            return self.navigateToCourseList()
            
        case .popViewController:
            self.rootViewController.popViewController(animated: true)
            return .none
            
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
    
    private func navigateToSpotDetail(spot: Spot) -> FlowContributors {
        let reactor = SpotDetailViewReactor(spot: spot)
        let viewController = SpotDetailViewController(reactor: reactor)
        
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToCourseList() -> FlowContributors {
//        let reactor = CourseListViewReactor()
//        let viewController = CourseViewController(reactor: reactor)
//
//        self.rootViewController.present(viewController, animated: true)
        return .none
    }
}
