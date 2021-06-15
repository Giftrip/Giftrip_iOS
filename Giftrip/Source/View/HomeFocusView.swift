//
//  HomeFocusView.swift
//  Giftrip
//
//  Created by 강민석 on 2021/06/13.
//

import UIKit

final class HomeFocusView: UIView {
    
    struct Font {
        static let titleLabel = UIFont.systemFont(ofSize: 16, weight: .semibold)
        static let descriptionLabel = UIFont.systemFont(ofSize: 12, weight: .medium)
        static let addressLabel = UIFont.systemFont(ofSize: 10, weight: .regular)
    }
    
    struct Metric {
        static let thumbanilImageWidth = 100.f
        static let titleLabelLeft = 10.f
        static let descriptionLabelTop = 5.f
        
        static let viewLeftRightPadding = 15.f
        static let viewTopBottomPadding = 15.f
    }
    
    let innerView = UIView()
    
    let thumbnailImage = UIImageView()
    
    let titleLabel = UILabel().then {
        $0.font = Font.titleLabel
        $0.textAlignment = .left
    }
    
    let descriptionLabel = UILabel().then {
        $0.font = Font.descriptionLabel
        $0.numberOfLines = 2
    }
    
    let addressLabel = UILabel().then {
        $0.font = Font.addressLabel
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        self.addSubview(self.innerView)
        
        // UI 등록
        self.innerView.addSubview(self.thumbnailImage)
        self.innerView.addSubview(self.titleLabel)
        self.innerView.addSubview(self.descriptionLabel)
        self.innerView.addSubview(self.addressLabel)
        
        // innerView cornerRadius 설정
        self.innerView.layer.cornerRadius = 8
        self.innerView.layer.masksToBounds = true
        
        // shadow 설정
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 6
        
        // cornerRadius 설정
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSpot(spot: Spot) {
        self.thumbnailImage.kf.setImage(with: spot.thumbnails.first)
        self.titleLabel.text = spot.title
        self.descriptionLabel.text = spot.description
        self.addressLabel.text = spot.address
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.innerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.thumbnailImage.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.equalTo(Metric.thumbanilImageWidth)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.left.equalTo(self.thumbnailImage.snp.right).offset(Metric.titleLabelLeft)
            make.top.equalToSuperview().offset(Metric.viewTopBottomPadding)
            make.right.equalToSuperview().offset(-Metric.viewLeftRightPadding)
        }
        
        self.descriptionLabel.snp.makeConstraints { make in
            make.left.equalTo(self.titleLabel.snp.left)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(Metric.descriptionLabelTop)
            make.right.equalToSuperview().offset(-Metric.viewLeftRightPadding)
        }
        
        self.addressLabel.snp.makeConstraints { make in
            make.left.equalTo(self.titleLabel.snp.left)
            make.bottom.equalToSuperview().offset(-Metric.viewTopBottomPadding)
            make.right.equalToSuperview().offset(-Metric.viewLeftRightPadding)
        }
    }
}
