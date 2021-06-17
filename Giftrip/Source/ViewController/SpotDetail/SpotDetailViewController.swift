//
//  SpotDetailViewController.swift
//  Giftrip
//
//  Created by 강민석 on 2021/06/15.
//

import UIKit

import ReactorKit
import ImageSlideshow
import CoreNFC

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
        
        reactor.alertTrigger
            .subscribe(onNext: {
                let alert = UIAlertController(title: "관련 영상 시청", message: "취소시 즉시 퀴즈로 넘어갑니다.", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "취소", style: .destructive) { _ in
                    reactor.action.onNext(.showQuiz)
                }
                
                let okAction = UIAlertAction(title: "확인", style: .default) { _ in
                    reactor.action.onNext(.showYouTube)
                }
                [cancelAction, okAction].forEach(alert.addAction)
                self.present(alert, animated: true)
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
        
        // MARK: - view
        self.imageSlideShow.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.imageSlideShow.presentFullScreenController(from: self!)
            }).disposed(by: disposeBag)
        
        self.nfcButton.rx.tap
            .subscribe(onNext: { _ in
                let session = NFCNDEFReaderSession(
                    delegate: self,
                    queue: nil,
                    invalidateAfterFirstRead: true
                )
                
                session.alertMessage = "스캔하는 동안 핸드폰을 고정해주세요."
                session.begin()
            })
            .disposed(by: disposeBag)
    }
}

extension SpotDetailViewController: NFCNDEFReaderSessionDelegate {
    
    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
        print("태그 스캔 시작")
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        if messages.count > 1 {
            // Restart polling in 500 milliseconds.
            let retryInterval = DispatchTimeInterval.milliseconds(500)
            session.alertMessage = "More than 1 tag is detected. Please remove all tags and try again."
            DispatchQueue.global().asyncAfter(deadline: .now() + retryInterval, execute: {
                session.restartPolling()
            })
            return
        }
        
        guard
            let message = messages.first,
            let record = message.records.first,
            let nfcCode = String(data: record.payload, encoding: .utf8)
        else {
            return
        }
        
        print(nfcCode)
        session.alertMessage = "태그 읽기 성공"
        
        DispatchQueue.main.async {
            self.reactor?.action.onNext(.nfcTagRead(nfcCode))
        }
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        session.alertMessage = "다시 시도해주세요!"
        return
    }
    
}
