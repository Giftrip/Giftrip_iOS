//
//  GiftripPlainButton.swift
//  Giftrip
//
//  Created by 강민석 on 2021/05/06.
//

import UIKit

class GiftripPlainButton: UIButton {
    
    struct Style {
        static let buttonCornerRadius = 6.f
        static let buttonTitle = UIFont.systemFont(ofSize: 16, weight: .semibold)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setTitle("Default Title", for: .normal)
        self.titleLabel?.font = Style.buttonTitle
        self.layer.cornerRadius = Style.buttonCornerRadius
        self.backgroundColor = R.color.accentColor()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.2) {
                if oldValue == false && self.isHighlighted {
                    self.alpha = 0.7
                } else if oldValue == true && !self.isHighlighted {
                    self.alpha = 1.0
                }
            }
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            UIView.animate(withDuration: 0.3) {
                if self.isEnabled {
                    self.alpha = 1.0
                } else {
                    self.alpha = 0.4
                }
            }
        }
    }
}
