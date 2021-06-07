//
//  HomeViewController.swift
//  Giftrip
//
//  Created by 강민석 on 2021/05/31.
//

import UIKit

import NMapsMap
import ReactorKit
import RxGesture
import DrawerView

final class HomeViewController: BaseViewController, ReactorKit.View {
    
    typealias Reactor = HomeViewReactor
    
    // MARK: Constants
    struct Metric {
        static let searchBarTop = 15.f
        static let searchBarLeftRight = 20.f
        static let searchBarHeight = 50.f
        
        static let drawerViewCollapsedHeight = 60.f
        static let drawerViewCornerRadius = 10.f
    }
    
    struct Font {
        
    }

    // MARK: - Properties

    // MARK: - UI
    fileprivate let mapView = NMFNaverMapView().then {
        $0.mapView.logoMargin.bottom = 60
    }
    fileprivate let courseSearchBarView = CourseSearchBarView()
    
    fileprivate var drawerView: DrawerView!

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
        
        self.view.addSubview(self.mapView)
        self.view.addSubview(self.courseSearchBarView)
        self.setupDrawer()
    }
    
    func setupDrawer() {
        let reactor = SpotListViewReactor()
        let viewController = SpotListViewController(reactor: reactor)
        self.drawerView = self.addDrawerView(withViewController: viewController)
        
        drawerView.snapPositions = [.collapsed, .open]
        drawerView.insetAdjustmentBehavior = .superviewSafeArea
        drawerView.cornerRadius = Metric.drawerViewCornerRadius
        drawerView.collapsedHeight = Metric.drawerViewCollapsedHeight
        drawerView.backgroundEffect = .none
        drawerView.backgroundColor = .white
        drawerView.overlayVisibilityBehavior = .disabled
        
        let drawerViewOpenHeight = self.view.safeAreaLayoutGuide.layoutFrame.size.height - (150 + Metric.searchBarTop + Metric.searchBarHeight)
        drawerView.openHeightBehavior = .fixed(height: drawerViewOpenHeight)
    }

    override func setupConstraints() {
        self.mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.courseSearchBarView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(Metric.searchBarTop)
            make.left.equalToSuperview().offset(Metric.searchBarLeftRight)
            make.right.equalToSuperview().offset(-Metric.searchBarLeftRight)
            make.height.equalTo(Metric.searchBarHeight)
        }
    }

    // MARK: - Configuring
    func bind(reactor: Reactor) {
        // MARK: - input
//        self.courseSearchBarView.rx.tapGesture()
//            .when(.recognized)
//            .map { Reactor.Action.presentCourseList }
//            .bind(to: reactor.action)
//            .disposed(by: disposeBag)
        
        // MARK: - output
        
        
    }
}
