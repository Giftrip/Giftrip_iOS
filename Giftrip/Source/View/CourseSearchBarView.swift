//
//  CourseSearchBarView.swift
//  Giftrip
//
//  Created by 강민석 on 2021/05/31.
//

import UIKit

final class CourseSearchBarView: UIView {
    
    let iconImage = UIImageView().then {
        $0.image = R.image.search()
    }
    
    let label = UILabel().then {
        $0.text = "더 많은 코스 찾아보기"
        $0.textColor = .systemGray
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.iconImage)
        self.addSubview(self.label)
        
        self.backgroundColor = .white
        
        self.layer.cornerRadius = 8
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 6
        self.layer.masksToBounds = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.iconImage.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
        }
        
        self.label.snp.makeConstraints { make in
            make.left.equalTo(self.iconImage.snp.right).offset(10)
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
