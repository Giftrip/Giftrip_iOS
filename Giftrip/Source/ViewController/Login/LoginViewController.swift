//
//  LoginViewController.swift
//  Giftrip
//
//  Created by 강민석 on 2021/05/06.
//

import UIKit

import ReactorKit

final class LoginViewController: BaseViewController, View {
    
    typealias Reactor = LoginViewReactor
    
    // MARK: Constants
    struct Metric {
        static let appLogoTop = 70.f
        
        static let stackViewLeftRight = 20.f
        static let stackViewTop = 100.f
        
        static let buttonLeftRight = 20.f
        static let buttonHeight = 50.f
        static let buttonBottom = 20.f
    }
    
    // MARK: - Properties

    // MARK: - UI
    let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 30
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.alignment = .fill
        $0.distribution = .fillEqually
    }
    
    let appLogoImageView = UIImageView().then {
        $0.image = R.image.appLogo()
    }
    
    let phoneTextField = GiftripTextField().then {
        $0.textField.placeholder = "전화번호"
        $0.textField.keyboardType = .numberPad
    }
    
    let passwordTextField = GiftripTextField().then {
        $0.textField.placeholder = "비밀번호"
        $0.textField.isSecureTextEntry = true
    }
    
    let loginButton = GiftripPlainButton().then {
        $0.setTitle("로그인", for: .normal)
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
        self.view.addSubview(self.stackView)
        self.stackView.addArrangedSubview(self.phoneTextField)
        self.stackView.addArrangedSubview(self.passwordTextField)
        self.view.addSubview(self.loginButton)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        self.appLogoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(Metric.appLogoTop)
        }
        
        self.stackView.snp.makeConstraints { make in
            make.top.equalTo(self.appLogoImageView.snp.bottom).offset(Metric.stackViewTop)
            make.left.equalToSuperview().offset(Metric.stackViewLeftRight)
            make.right.equalToSuperview().offset(-Metric.stackViewLeftRight)
            make.height.equalTo(130)
        }
        
        self.loginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            
            make.left.equalToSuperview().offset(Metric.buttonLeftRight)
            make.right.equalToSuperview().offset(-Metric.buttonLeftRight)
            make.height.equalTo(Metric.buttonHeight)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-Metric.buttonBottom)
        }
    }

    // MARK: - Configuring
    func bind(reactor: Reactor) {
        // MARK: - input
        self.phoneTextField.textField.rx.text.orEmpty
            .map(Reactor.Action.validPhone)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.passwordTextField.textField.rx.text.orEmpty
            .map(Reactor.Action.validPassword)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.loginButton.rx.tap
            .map { Reactor.Action.login }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: - output
        
        let phoneValidation = reactor.state.map { $0.phoneValidation }.distinctUntilChanged()
        let passwordValidation = reactor.state.map { $0.passwordValidation }.distinctUntilChanged()
        
        phoneValidation
            .bind(to: self.phoneTextField.rx.error)
            .disposed(by: disposeBag)
        
        passwordValidation
            .bind(to: self.passwordTextField.rx.error)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            phoneValidation,
            passwordValidation
        ) { $0 && $1 }
        .bind(to: self.loginButton.rx.isEnabled)
        .disposed(by: disposeBag)
        
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: self.activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
    }
}
