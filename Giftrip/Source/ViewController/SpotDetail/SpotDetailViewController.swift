//
//  SpotDetailViewController.swift
//  Giftrip
//
//  Created by 강민석 on 2021/06/15.
//

import UIKit

import ReactorKit
import ImageSlideshow

final class SpotDetailViewController: BaseViewController, View {
    
    typealias Reactor = SpotDetailViewReactor
    
    // MARK: Constants
    struct Metric {
        static let leftRightPadding = 20.f
        static let imageSlideShowHeight = 250.f
        static let titleLabelTop = 20.f
        static let addressLabelTop = 10.f
        static let descriptionLabelTop = 10.f
        
        static let buttonLeftRight = 20.f
        static let buttonHeight = 50.f
        static let buttonBottom = 20.f
        static let mapButtonBottom = 15.f
    }
    
    struct Font {
        static let titleLabel = UIFont.systemFont(ofSize: 24, weight: .semibold)
        static let addressLabel = UIFont.systemFont(ofSize: 16, weight: .regular)
        static let descriptionLabel = UIFont.systemFont(ofSize: 16, weight: .regular)
    }

    // MARK: - Properties

    // MARK: - UI
    let imageSlideShow = ImageSlideshow().then {
        $0.contentScaleMode = .scaleToFill
    }
    
    let titleLabel = UILabel().then {
        $0.font = Font.titleLabel
    }
    
    let addressLabel = UILabel().then {
        $0.font = Font.addressLabel
    }
    
    let descriptionLabel = UILabel().then {
        $0.font = Font.descriptionLabel
        $0.numberOfLines = 0
    }
    
    let mapButton = GiftripPlainButton().then {
        $0.setTitle("지도에서 보기", for: .normal)
        $0.backgroundColor = .lightGray
    }
    
    let nfcButton = GiftripPlainButton().then {
        $0.setTitle("NFC 인증하기", for: .normal)
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
        
        self.view.addSubview(self.imageSlideShow)
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.addressLabel)
        self.view.addSubview(self.descriptionLabel)
        self.view.addSubview(self.mapButton)
        self.view.addSubview(self.nfcButton)
    }

    override func setupConstraints() {
        super.setupConstraints()
        
        self.imageSlideShow.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.height.equalTo(Metric.imageSlideShowHeight)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Metric.leftRightPadding)
            make.right.equalToSuperview().offset(-Metric.leftRightPadding)
            make.top.equalTo(self.imageSlideShow.snp.bottom).offset(Metric.titleLabelTop)
        }
        
        self.addressLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Metric.leftRightPadding)
            make.right.equalToSuperview().offset(-Metric.leftRightPadding)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(Metric.addressLabelTop)
        }
        
        self.descriptionLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Metric.leftRightPadding)
            make.right.equalToSuperview().offset(-Metric.leftRightPadding)
            make.top.equalTo(self.addressLabel.snp.bottom).offset(Metric.descriptionLabelTop)
        }
        
        self.mapButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Metric.buttonLeftRight)
            make.right.equalToSuperview().offset(-Metric.buttonLeftRight)
            make.height.equalTo(Metric.buttonHeight)
            make.bottom.equalTo(self.nfcButton.snp.top).offset(-Metric.mapButtonBottom)
        }
        
        self.nfcButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Metric.buttonLeftRight)
            make.right.equalToSuperview().offset(-Metric.buttonLeftRight)
            make.height.equalTo(Metric.buttonHeight)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-Metric.buttonBottom)
        }
    }

    // MARK: - Configuring
    func bind(reactor: Reactor) {
        // MARK: - action
        self.mapButton.rx.tap
            .map { Reactor.Action.moveToMap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: - state
        reactor.state.map { $0.title }
            .bind(to: self.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.address }
            .bind(to: self.addressLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.description }
            .bind(to: self.descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.images }
            .subscribe(onNext: { [weak self] images in
                var imageInputs = [KingfisherSource]()
                images.forEach { url in
                    imageInputs.append(KingfisherSource(url: url))
                }
                self?.imageSlideShow.setImageInputs(imageInputs)
            })
            .disposed(by: disposeBag)
        
        // MARK: - view
        self.imageSlideShow.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.imageSlideShow.presentFullScreenController(from: self!)
            }).disposed(by: disposeBag)
    }
}
