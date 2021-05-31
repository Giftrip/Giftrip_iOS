//
//  IntroViewController.swift
//  Giftrip
//
//  Created by 강민석 on 2021/05/06.
//

import UIKit

import ReactorKit

final class IntroViewController: BaseViewController, View {
    
    typealias Reactor = IntroViewReactor
    
    // MARK: Constants
    struct Metric {
        static let appLogoTop = 70.f
        static let buttonBottom = 15.f
        static let buttonHeight = 50.f
        static let buttonLeftRight = 20.f
    }
    
    struct Font {
        static let privacyPolicyButtonFont = UIFont.systemFont(ofSize: 18, weight: .light)
    }

    // MARK: - Properties

    // MARK: - UI
    let appLogoImageView = UIImageView().then {
        $0.image = R.image.appLogo()
    }
    
    let splashImageView = UIImageView().then {
        $0.image = R.image.splashImage()
        $0.contentMode = .scaleAspectFill
    }
    
    let loginButton = GiftripPlainButton().then {
        $0.setTitle("로그인", for: .normal)
    }
    
    let registerButton = GiftripPlainButton().then {
        $0.setTitle("회원가입", for: .normal)
    }
    
    let privacyPolicyButton = UIButton().then {
        $0.setTitle("개인정보 처리 방침", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = Font.privacyPolicyButtonFont
    }

    // MARK: - Initializing
    init(
        reactor: Reactor
    ) {
        defer { self.reactor = reactor }
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.appLogoImageView)
        self.view.addSubview(self.splashImageView)
        self.view.addSubview(self.loginButton)
        self.view.addSubview(self.registerButton)
        self.view.addSubview(self.privacyPolicyButton)
    }

    override func setupConstraints() {
        self.appLogoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(Metric.appLogoTop)
        }
        
        self.splashImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
        }
        
        self.loginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(Metric.buttonLeftRight)
            make.right.equalToSuperview().offset(-Metric.buttonLeftRight)
            make.bottom.equalTo(self.registerButton.snp.top).offset(-Metric.buttonBottom)
            make.height.equalTo(Metric.buttonHeight)
        }
        
        self.registerButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(Metric.buttonLeftRight)
            make.right.equalToSuperview().offset(-Metric.buttonLeftRight)
            make.bottom.equalTo(self.privacyPolicyButton.snp.top).offset(-Metric.buttonBottom)
            make.height.equalTo(Metric.buttonHeight)
        }
        
        self.privacyPolicyButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-Metric.buttonBottom)
        }
    }

    // MARK: - Configuring
    func bind(reactor: Reactor) {
        // MARK: - input
        self.loginButton.rx.tap
            .map { Reactor.Action.login }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.registerButton.rx.tap
            .map { Reactor.Action.register }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.privacyPolicyButton.rx.tap
            .map { Reactor.Action.privacyPolicy }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}
