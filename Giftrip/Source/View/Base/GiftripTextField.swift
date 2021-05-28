//
//  GiftripTextField.swift
//  Giftrip
//
//  Created by 강민석 on 2021/05/06.
//

import UIKit
import RxSwift
import RxCocoa

class GiftripTextField: UIView {
    
    let disposeBag = DisposeBag()
    
    // MARK: Constants
    fileprivate struct Metric {
        static let textFieldTop = 10.f
        static let textFieldLeftRight = 15.f
        static let iconRight = 12.f
        static let iconSize = 20.f
    }
    
    fileprivate struct Font {
        static let textField = UIFont.systemFont(ofSize: 17, weight: .medium)
    }
    
    // MARK: - Properties
    
    // MARK: - UI
    let textField = UITextField().then {
        $0.font = Font.textField
        $0.clearButtonMode = .whileEditing
    }
    
    let icon = UIImageView().then {
        $0.image = R.image.caution()
        $0.contentMode = .scaleAspectFit
    }

    // MARK: - Initializing
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.layer.cornerRadius = 6
        self.layer.masksToBounds = true
        self.layer.borderWidth = 0.5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addSubview(self.textField)
        self.addSubview(self.icon)
        
        self.icon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-Metric.iconRight)
            make.width.height.equalTo(Metric.iconSize)
        }
        
        self.textField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.snp.left).offset(Metric.textFieldLeftRight)
            make.right.equalTo(self.icon.snp.left).offset(-Metric.textFieldLeftRight)
        }
    }
}

extension Reactive where Base: GiftripTextField {
    var error: Binder<Bool> {
        return Binder(self.base) { textField, validation in
            if validation {
                textField.icon.image = R.image.check()
            } else {
                textField.icon.image = R.image.caution()
            }
        }
    }
}
