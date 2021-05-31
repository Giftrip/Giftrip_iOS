//
//  RegisterPhoneViewController.swift
//  Giftrip
//
//  Created by 강민석 on 2021/05/06.
//

import UIKit

import ReactorKit
import SwiftMessages

final class RegisterPhoneViewController: BaseViewController, View {
    
    typealias Reactor = RegisterPhoneViewReactor
    
    struct Metric {
        static let titleLabelLeftRight = 20.f
        static let titleLabelTop = 130.f
        
        static let textFieldLeftRight = 20.f
        static let textFieldTop = 30.f
        static let textFieldHeight = 50.f
        
        static let buttonLeftRight = 20.f
        static let buttonHeight = 50.f
        static let buttonBottom = 20.f
    }
    
    struct Font {
        static let titleLabel = UIFont.systemFont(ofSize: 23, weight: .semibold)
    }
    
    // MARK: - Properties
    
    // MARK: - UI
    fileprivate let titleLabel = UILabel().then {
        $0.text = "전화번호와\n비밀번호를 입력해주세요"
        $0.font = Font.titleLabel
        $0.numberOfLines = 0
    }
    
    fileprivate let phoneNumberTextField = GiftripTextField().then {
        $0.textField.placeholder = "전화번호"
        $0.textField.keyboardType = .phonePad
    }
    
    fileprivate let passwordTextField = GiftripTextField().then {
        $0.textField.placeholder = "비밀번호"
        $0.textField.isSecureTextEntry = true
    }
    
    fileprivate let nextButton = GiftripPlainButton().then {
        $0.setTitle("다음", for: .normal)
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
        
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.phoneNumberTextField)
        self.view.addSubview(self.passwordTextField)
        self.view.addSubview(self.nextButton)
        
    }
    override func setupConstraints() {
        super.setupConstraints()
        
        self.titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(Metric.titleLabelTop)
            make.left.equalToSuperview().offset(Metric.titleLabelLeftRight)
            make.right.equalToSuperview().offset(-Metric.titleLabelLeftRight)
        }
        
        self.phoneNumberTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.titleLabel.snp.bottom).offset(Metric.textFieldTop)
            make.left.equalToSuperview().offset(Metric.textFieldLeftRight)
            make.right.equalToSuperview().offset(-Metric.textFieldLeftRight)
            make.height.equalTo(Metric.textFieldHeight)
        }
        
        self.passwordTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.phoneNumberTextField.snp.bottom).offset(Metric.textFieldTop)
            make.left.equalToSuperview().offset(Metric.textFieldLeftRight)
            make.right.equalToSuperview().offset(-Metric.textFieldLeftRight)
            make.height.equalTo(Metric.textFieldHeight)
        }
        
        self.nextButton.snp.makeConstraints { make in
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
        self.phoneNumberTextField.textField.rx.text.orEmpty
            .map(Reactor.Action.setPhoneNumber)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.passwordTextField.textField.rx.text.orEmpty
            .map(Reactor.Action.setPassword)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.nextButton.rx.tap
            .map { Reactor.Action.next }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: - output
        let phoneValidation = reactor.state
            .map { $0.phoneNumberValidation }
            .distinctUntilChanged()
        
        let passwordValidation = reactor.state
            .map { $0.passwordValidation }
            .distinctUntilChanged()
        
        phoneValidation
            .bind(to: self.phoneNumberTextField.rx.error)
            .disposed(by: disposeBag)
        
        passwordValidation
            .bind(to: self.passwordTextField.rx.error)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            phoneValidation,
            passwordValidation
        ).map { $0 && $1 }
        .bind(to: self.nextButton.rx.isEnabled )
        .disposed(by: disposeBag)
        
        reactor.state.map { $0.authCodeResponse }
            .filterNil()
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] response in
                self?.messageManager.show(config: Message.timerConfig, view: Message.timerView(response.expireAt))
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.error }
            .filterNil()
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] error in
                self?.messageManager.show(config: Message.bottomConfig, view: Message.faildView(error.message))
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: self.activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
    }
}
