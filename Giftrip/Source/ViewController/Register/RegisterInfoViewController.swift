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
        
        static let textFieldLeftRight = 20.f
        static let textFieldTop = 30.f
        static let textFieldHeight = 50.f
        
        static let buttonLeftRight = 20.f
        static let buttonHeight = 50.f
        static let buttonBottom = 20.f
    }
    
    struct Font {
        static let titleLabel = UIFont.systemFont(ofSize: 23, weight: .bold)
    }
    
    // MARK: - Properties

    // MARK: - UI
    let titleLabel = UILabel().then {
        $0.text = "회원가입을 위해\n간단한 정보를 입력해주세요"
        $0.font = Font.titleLabel
        $0.numberOfLines = 0
    }
    
    let nameTextField = GiftripTextField().then {
        $0.textField.placeholder = "이름"
    }
    
    let doneButton = KeyboardTopButton()
    let datePicker = UIDatePicker(
        frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 216)
    ).then {
        $0.datePickerMode = .date
    }
    lazy var birthTextField = GiftripTextField().then {
        $0.textField.placeholder = "생년월일"
        
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.sizeToFit()
        }
        $0.textField.inputView = datePicker
        $0.textField.inputAccessoryView = doneButton
    }
    
    let nextButton = GiftripPlainButton().then {
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
        self.view.addSubview(self.nameTextField)
        self.view.addSubview(self.birthTextField)
        self.view.addSubview(self.nextButton)
    }
    
    override func setupConstraints() {
        self.titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(Metric.titleLabelTop)
            make.left.equalToSuperview().offset(Metric.titleLabelLeftRight)
            make.right.equalToSuperview().offset(-Metric.titleLabelLeftRight)
        }
        
        self.nameTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.titleLabel.snp.bottom).offset(Metric.textFieldTop)
            make.left.equalToSuperview().offset(Metric.textFieldLeftRight)
            make.right.equalToSuperview().offset(-Metric.textFieldLeftRight)
            make.height.equalTo(Metric.textFieldHeight)
        }
        
        self.birthTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.nameTextField.snp.bottom).offset(Metric.textFieldTop)
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
        self.nameTextField.textField.rx.text.orEmpty
            .map(Reactor.Action.setName)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.doneButton.rx.tap
            .map {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                let date = self.datePicker.date
                self.birthTextField.textField.text = dateFormatter.string(from: date)
                self.view.endEditing(true)
                return Reactor.Action.setBirthDate(date)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.nextButton.rx.tap
            .map { Reactor.Action.next }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: - output
        reactor.state.map { $0.nameValidation }
            .distinctUntilChanged()
            .bind(to: self.nameTextField.rx.error)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.birthDateValidation }
            .distinctUntilChanged()
            .bind(to: self.birthTextField.rx.error)
            .disposed(by: disposeBag)
    }
}
