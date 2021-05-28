//
//  RegisterAuthCodeViewController.swift
//  Giftrip
//
//  Created by 강민석 on 2021/05/27.
//

import UIKit

import ReactorKit

final class RegisterAuthCodeViewController: BaseViewController, View {
    
    typealias Reactor = RegisterAuthCodeViewReactor
    
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
        $0.text = "인증번호가 일치하면\n회원가입이 완료됩니다"
        $0.font = Font.titleLabel
        $0.numberOfLines = 0
    }
    
    fileprivate let authCodeTextField = GiftripTextField().then {
        $0.textField.placeholder = "인증번호"
        $0.icon.image = UIImage()
    }
    
    fileprivate let registerButton = GiftripPlainButton().then {
        $0.setTitle("회원가입", for: .normal)
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
        self.view.addSubview(self.authCodeTextField)
        self.view.addSubview(self.registerButton)
        
    }
    override func setupConstraints() {
        super.setupConstraints()
        
        self.titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(Metric.titleLabelTop)
            make.left.equalToSuperview().offset(Metric.titleLabelLeftRight)
            make.right.equalToSuperview().offset(-Metric.titleLabelLeftRight)
        }
        
        self.authCodeTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.titleLabel.snp.bottom).offset(Metric.textFieldTop)
            make.left.equalToSuperview().offset(Metric.textFieldLeftRight)
            make.right.equalToSuperview().offset(-Metric.textFieldLeftRight)
            make.height.equalTo(Metric.textFieldHeight)
        }
        
        self.registerButton.snp.makeConstraints { make in
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
        self.authCodeTextField.textField.rx.text.orEmpty
            .map(Reactor.Action.setAuthCode)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.registerButton.rx.tap
            .map { Reactor.Action.register }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: - output
        reactor.state.map { $0.authCodeValidation }
            .bind(to: self.registerButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isLoading }
            .bind(to: self.activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.successMessage }
            .filterNil()
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] message in
                self?.messageManager.show(config: Message.bottomConfig, view: Message.successView(message))
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.error }
            .filterNil()
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] error in
                self?.messageManager.show(config: Message.bottomConfig, view: Message.faildView(error.message))
            })
            .disposed(by: disposeBag)
    }
}
