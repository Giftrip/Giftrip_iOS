//
//  IntroFlow.swift
//  Giftrip
//
//  Created by 강민석 on 2021/05/06.
//

import RxFlow

final class IntroFlow: Flow {
    
    // MARK: - Properties
    private let services: AppServices
    
    var root: Presentable {
        return self.rootViewController
    }
    
    var name: String = ""
    var birth: Date = Date()
    
    private lazy var rootViewController = UINavigationController().then {
        $0.navigationBar.setBackgroundImage(UIImage(), for: .default)
        $0.navigationBar.shadowImage = UIImage()
        $0.navigationBar.isTranslucent = true
    }
    
    // MARK: - Init
    init(_ services: AppServices) {
        self.services = services
    }
    
    deinit {
        print("❎ \(type(of: self)): \(#function)")
    }
    
    // MARK: - Navigation Switch
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? GiftripStep else { return .none }
        
        switch step {
        // 인트로 화면
        case .introIsRequired:
            return navigateToIntro()
            
        // 개인정보처리방침 화면
        case .privacyPolicyIsRequired:
            return navigateToPrivacyPolicy()
            
        // 로그인
        case .loginIsRequired:
            return navigateToLogin()
        
        // 회원가입 - 간단 정보
        case .registerInfoIsRequired:
            return navigateToRegisterInfo()
            
        // 회원가입 - 전화번호, 비밀번호
        case let .registerPhoneIsRequired(name, birth):
            self.name = name
            self.birth = birth
            return navigateToRegisterPhone()
            
        // 회원가입 - 인증번호
        case let .registerAuthCodeIsRequired(phone, password):
            return navigateToRegisterAuthCode(phone, password)
            
        // 메인화면
        case .mainTabBarIsRequired:
            return .end(forwardToParentFlowWithStep: GiftripStep.mainTabBarIsRequired)
        
        case .dismiss:
            self.rootViewController.dismiss(animated: true, completion: nil)
            return .none
            
        default:
            return .none
        }
    }
}

extension IntroFlow {
    
    /// Initial Navigate
    private func navigateToIntro() -> FlowContributors {
        let reactor = IntroViewReactor()
        let viewController = IntroViewController(reactor: reactor)
        
        self.rootViewController.pushViewController(viewController, animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToPrivacyPolicy() -> FlowContributors {
        let reactor = PrivacyPolicyViewReactor()
        let viewController = PrivacyPolicyViewController(reactor: reactor)
        
        self.rootViewController.present(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToLogin() -> FlowContributors {
        let reactor = LoginViewReactor(authService: self.services.authService, userService: self.services.userService)
        let viewController = LoginViewController(reactor: reactor)
        
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToRegisterInfo() -> FlowContributors {
        let reactor = RegisterInfoViewReactor()
        let viewController = RegisterInfoViewController(reactor: reactor)
        
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToRegisterPhone() -> FlowContributors {
        let reactor = RegisterPhoneViewReactor(authService: self.services.authService)
        let viewController = RegisterPhoneViewController(reactor: reactor)
        
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToRegisterAuthCode(_ phone: String, _ password: String) -> FlowContributors {
        let reactor = RegisterAuthCodeViewReactor(
            authService: self.services.authService,
            userService: self.services.userService,
            name: self.name,
            birth: self.birth,
            phone: phone,
            password: password
        )
        let viewController = RegisterAuthCodeViewController(reactor: reactor)
        
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
}
