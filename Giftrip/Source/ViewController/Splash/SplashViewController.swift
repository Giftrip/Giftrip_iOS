//
//  SplashViewController.swift
//  Giftrip
//
//  Created by 강민석 on 2021/05/06.
//

import UIKit

import ReactorKit

final class SplashViewController: BaseViewController, View {
    
    typealias Reactor = SplashViewReactor
    
    // MARK: Constants
    struct Metric {
        static let appLogoTop = 70.f
        static let titleLabelBottom = 50.f
    }
    
    struct Font {
        static let titleLabel = UIFont.systemFont(ofSize: 18, weight: .medium)
    }

    // MARK: - Properties

    // MARK: - UI
    let splashLabel = UILabel().then {
        $0.text = "Giftrip으로 의미 있는 여행을!"
        $0.font = Font.titleLabel
    }
    
    let splashImageView = UIImageView().then {
        $0.image = R.image.splashImage()
        $0.contentMode = .scaleAspectFill
    }
    
    let appLogoImageView = UIImageView().then {
        $0.image = R.image.appLogo()
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
        
        self.view.addSubview(self.appLogoImageView)
        self.view.addSubview(self.splashImageView)
        self.view.addSubview(self.splashLabel)
    }

    override func setupConstraints() {
        self.appLogoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(Metric.appLogoTop)
        }
        
        self.splashImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
        }
        
        self.splashLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-Metric.titleLabelBottom)
        }
    }

    // MARK: - Configuring
    func bind(reactor: Reactor) {
        // MARK: - input
        Observable.just(Reactor.Action.branchView)
            .delay(.seconds(1), scheduler: MainScheduler.instance)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: - output
        reactor.errorRelay
            .subscribe(onNext: { [weak self] error in
                self?.messageManager.show(config: Message.bottomConfig, view: Message.faildView(error.localizedDescription))
            })
            .disposed(by: disposeBag)
    }
}
