//
//  SpotListCell.swift
//  Giftrip
//
//  Created by 강민석 on 2021/06/08.
//

import UIKit

import ReactorKit

final class SpotListCell: BaseTableViewCell, View {
    
    typealias Reactor = SpotListCellReactor
    
    struct Font {
        static let titleLabel = UIFont.systemFont(ofSize: 16, weight: .semibold)
        static let descriptionLabel = UIFont.systemFont(ofSize: 12, weight: .medium)
        static let addressLabel = UIFont.systemFont(ofSize: 10, weight: .regular)
    }
    
    struct Metric {
        static let thumbanilImageSize = 80.f
        static let titleLabelLeft = 10.f
        static let descriptionLabelTop = 5.f
        
        static let cellLeftRightPadding = 15.f
        static let cellTopBottomPadding = 15.f
    }
    
    let thumbnailImage = UIImageView().then {
        $0.layer.cornerRadius = 4
        $0.layer.masksToBounds = true
    }
    
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
    
    let completeIcon = UIImageView().then {
        $0.image = R.image.caution()
        $0.isHidden = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(self.thumbnailImage)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.descriptionLabel)
        self.contentView.addSubview(self.addressLabel)
        self.contentView.addSubview(self.completeIcon)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.thumbnailImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(Metric.cellLeftRightPadding)
            make.width.height.equalTo(Metric.thumbanilImageSize)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.left.equalTo(self.thumbnailImage.snp.right).offset(Metric.titleLabelLeft)
            make.top.equalToSuperview().offset(Metric.cellTopBottomPadding)
        }
        
        self.descriptionLabel.snp.makeConstraints { make in
            make.left.equalTo(self.titleLabel.snp.left)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(Metric.descriptionLabelTop)
            make.right.equalToSuperview().offset(-Metric.cellLeftRightPadding)
        }
        
        self.addressLabel.snp.makeConstraints { make in
            make.left.equalTo(self.titleLabel.snp.left)
            make.bottom.equalToSuperview().offset(-Metric.cellTopBottomPadding)
            make.right.equalToSuperview()
        }
        
        self.completeIcon.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-Metric.cellLeftRightPadding)
            make.top.equalTo(self.thumbnailImage.snp.top)
        }
    }
    
    func bind(reactor: Reactor) {
        reactor.state.map { $0.address }
            .bind(to: self.addressLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { !$0.completed }
            .bind(to: self.completeIcon.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.description }
            .bind(to: self.descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.title }
            .bind(to: self.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.thumbnail }
            .bind(to: self.thumbnailImage.rx.image())
            .disposed(by: disposeBag)
    }
}
