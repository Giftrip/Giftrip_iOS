//
//  RegisterInfoViewController.swift
//  Giftrip
//
//  Created by 강민석 on 2021/05/06.
//

import UIKit

import ReactorKit

final class RegisterInfoViewController: BaseViewController, View {
    
    typealias Reactor = RegisterInfoViewReactor
    
    // MARK: Constants
    struct Metric {
        static let titleLabelLeftRight = 20.f
        static let titleLabelTop = 130.f
        
        static let stackViewLeftRight = 20.f
        static let stackViewTop = 20.f
        
        static let buttonLeftRight = 20.f
        static let buttonHeight = 50.f
        static let buttonBottom = 20.f
    }
    
    struct Font {
        static let titleLabel = UIFont.systemFont(ofSize: 23, weight: .bold)
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
    
    let titleLabel = UILabel().then {
        $0.text = "회원가입을 위해\n간단한 정보를 입력해주세요"
        $0.font = Font.titleLabel
        $0.numberOfLines = 0
    }
    
    let nameTextField = GiftripTextField().then {
        $0.textField.placeholder = "이름"
    }
    
    let birthTextField = GiftripTextField().then {
        $0.textField.placeholder = "생년월일"
    }
    
    let passwordTextField = GiftripTextField().then {
        $0.textField.placeholder = "비밀번호"
    }
    
    let authCodeTextField = GiftripTextField().then {
        $0.textField.placeholder = "인증번호"
    }
    
    let nextButton = GiftripPlainButton().then {
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
        self.view.addSubview(self.stackView)
        self.stackView.addArrangedSubview(self.nameTextField)
        self.stackView.addArrangedSubview(self.birthTextField)
        self.stackView.addArrangedSubview(self.passwordTextField)
        self.stackView.addArrangedSubview(self.authCodeTextField)
        self.view.addSubview(self.nextButton)
    }
    override func setupConstraints() {
        self.titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(Metric.titleLabelTop)
            make.left.equalToSuperview().offset(Metric.titleLabelLeftRight)
            make.right.equalToSuperview().offset(-Metric.titleLabelLeftRight)
        }
        
        self.stackView.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(Metric.stackViewTop)
            make.left.equalToSuperview().offset(Metric.stackViewLeftRight)
            make.right.equalToSuperview().offset(-Metric.stackViewLeftRight)
            make.height.equalTo(300)
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
        
        // MARK: - output
        
    }
}
