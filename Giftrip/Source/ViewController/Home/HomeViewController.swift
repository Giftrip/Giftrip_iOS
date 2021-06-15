//
//  HomeViewController.swift
//  Giftrip
//
//  Created by 강민석 on 2021/05/31.
//

import UIKit

import GoogleMaps
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
        
        static let focusViewHeight = 100.f
        static let focusViewLeftRight = 20.f
        static let focusViewBottom = 25.f
    }
    
    struct Font {
        
    }
    
    // MARK: - Properties
    
    // MARK: - UI
    fileprivate var camera: GMSCameraPosition!
    fileprivate lazy var mapView = GMSMapView(frame: self.view.frame)
    
    fileprivate let courseSearchBarView = CourseSearchBarView()
    fileprivate let homeFocusView = HomeFocusView().then {
        $0.isHidden = true
    }
    
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
        
        self.camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 18)
        self.mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        let mapInsets = UIEdgeInsets(top: 0, left: 0, bottom: Metric.drawerViewCollapsedHeight, right: 0)
        mapView.padding = mapInsets
        self.view.addSubview(self.mapView)
        
        self.mapView.delegate = self
        
        self.view.addSubview(self.courseSearchBarView)
        self.view.addSubview(self.homeFocusView)
        self.setupDrawer()
    }
    
    func setupDrawer() {
        guard let reactor = self.reactor?.spotListViewReactor else { return }
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
        self.courseSearchBarView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(Metric.searchBarTop)
            make.left.equalToSuperview().offset(Metric.searchBarLeftRight)
            make.right.equalToSuperview().offset(-Metric.searchBarLeftRight)
            make.height.equalTo(Metric.searchBarHeight)
        }
        
        self.homeFocusView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Metric.focusViewLeftRight)
            make.right.equalToSuperview().offset(-Metric.focusViewLeftRight)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-(Metric.drawerViewCollapsedHeight + Metric.focusViewBottom))
            make.height.equalTo(Metric.focusViewHeight)
        }
    }
    
    // MARK: - Configuring
    func bind(reactor: Reactor) {
        self.courseSearchBarView.rx.tapGesture()
            .when(.recognized)
            .map { _ in Reactor.Action.presentCourseList }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.currentLocation }
            .filterNil()
            .subscribe(onNext: { [weak self] spot in
                self?.drawerView.setPosition(.collapsed, animated: true)
                
                self?.homeFocusView.setSpot(spot: spot)
                self?.homeFocusView.isHidden = false
                
                self?.mapView.animate(
                    toLocation: CLLocationCoordinate2D(
                        latitude: spot.lat,
                        longitude: spot.lon
                    )
                )
                
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: spot.lat, longitude: spot.lon)
                //                marker.title = spot.title
                //                marker.snippet = spot.description
                marker.map = self?.mapView
                marker.userData = spot
            })
            .disposed(by: disposeBag)
        
            self.homeFocusView.rx.tapGesture()
                .when(.recognized)
                .map { _ in
                    Reactor.Action.selectSpot(self.homeFocusView.currentSpot!)
                }
                .bind(to: reactor.action)
                .disposed(by: disposeBag)
        
    }
}

extension HomeViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let spot = marker.userData as? Spot else { return false }
        
        self.homeFocusView.setSpot(spot: spot)
        
        if self.homeFocusView.isHidden == true {
            UIView.transition(with: self.homeFocusView, duration: 0.3, options: .transitionCrossDissolve) {
                self.homeFocusView.isHidden = false
            }
        }
        
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        if self.homeFocusView.isHidden == false {
            UIView.transition(with: self.homeFocusView, duration: 0.3, options: .transitionCrossDissolve) {
                self.homeFocusView.isHidden = true
            }
        }
    }
}
