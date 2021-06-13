//
//  SpotListViewController.swift
//  Giftrip
//
//  Created by 강민석 on 2021/05/31.
//

import UIKit

import ReactorKit
import ReusableKit
import RxDataSources

final class SpotListViewController: BaseViewController, View {
    
    typealias Reactor = SpotListViewReactor
    
    // MARK: Constants
    struct Reusable {
        static let spotListCell = ReusableCell<SpotListCell>()
    }
    
    struct Metric {
        static let barViewTop = 10.f
        static let courseNameLabelTop = 15.f
        static let barViewWidth = 55.f
        static let barViewHeight = 4.f
        static let dividerViewLeftRight = 15.f
        static let dividerViewHeight = 0.5.f
        static let tableViewTop = 10.f
    }
    
    struct Font {
        static let courseNameLabel = UIFont.systemFont(ofSize: 16, weight: .medium)
    }

    // MARK: - Properties
    
    fileprivate let dataSource: RxTableViewSectionedReloadDataSource<SpotListViewSection>

    // MARK: - UI
    let barView = UIView().then {
        $0.backgroundColor = .separator
        $0.layer.cornerRadius = 2
        $0.layer.masksToBounds = true
    }
    
    let courseNameLabel = UILabel().then {
        $0.text = "2.28"
        $0.font = Font.courseNameLabel
    }
    
    let dividerView = UIView().then {
        $0.backgroundColor = .separator
    }
    
    let refreshControl = RefreshControl()
    
    let tableView = UITableView(
        frame: .zero,
        style: .plain
    ).then {
        $0.separatorStyle = .none
        $0.register(Reusable.spotListCell)
    }
    
    static func dataSourceFactory() -> RxTableViewSectionedReloadDataSource<SpotListViewSection> {
        return .init(
            configureCell: { dataSource, tableView, indexPath, sectionItem in
                let cell = tableView.dequeue(Reusable.spotListCell, for: indexPath)
                switch sectionItem {
                case let .spotItem(reactor):
                    cell.reactor = reactor
                    return cell
                }
            },
            canEditRowAtIndexPath: { _, _ in
                return true
            }
        )
    }

    // MARK: - Initializing
    init(
        reactor: Reactor
    ) {
        defer { self.reactor = reactor }
        self.dataSource = Self.dataSourceFactory()
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.refreshControl = self.refreshControl
        self.view.addSubview(self.barView)
        self.view.addSubview(self.courseNameLabel)
        self.view.addSubview(self.dividerView)
        self.view.addSubview(self.tableView)
    }

    override func setupConstraints() {
        super.setupConstraints()
        
        self.barView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Metric.barViewTop)
            make.centerX.equalToSuperview()
            make.width.equalTo(Metric.barViewWidth)
            make.height.equalTo(Metric.barViewHeight)
        }
        
        self.courseNameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.barView.snp.bottom).offset(Metric.courseNameLabelTop)
        }
        
        self.dividerView.snp.makeConstraints { make in
            make.top.equalTo(self.courseNameLabel.snp.bottom).offset(Metric.courseNameLabelTop)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(Metric.dividerViewLeftRight)
            make.right.equalToSuperview().offset(-Metric.dividerViewLeftRight)
            make.height.equalTo(Metric.dividerViewHeight)
        }
        
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(self.dividerView.snp.bottom).offset(Metric.tableViewTop)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    // MARK: - Configuring
    func bind(reactor: Reactor) {
        // MARK: - Action
        self.rx.viewDidLoad
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.refreshControl.rx.controlEvent(.valueChanged)
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.tableView.rx.isReachedBottom
            .map { Reactor.Action.loadMore }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: - State
        reactor.state.map { $0.section }
            .bind(to: self.tableView.rx.items(dataSource: self.dataSource))
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isLoading }
            .bind(to: self.activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        // MARK: - View
        self.tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        self.tableView.rx.itemSelected
            .bind(to: self.tableView.rx.deselectRow)
            .disposed(by: disposeBag)
        
        self.tableView.rx.itemSelected(dataSource: self.dataSource)
            .subscribe(onNext: { [weak self] sectionItem in
                switch sectionItem {
                case let .spotItem(reactor):
                    let action = Reactor.Action.spotSelected(reactor.spot)
                    self?.reactor?.action.onNext(action)
                }
            })
            .disposed(by: disposeBag)
    }
}

extension SpotListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let locationShortCutButton = UIContextualAction(style: .normal, title: nil) { action, view, success in
            
            switch self.dataSource[indexPath] {
            case let .spotItem(reactor):
                self.reactor?.action.onNext(Reactor.Action.swipeSpot(reactor.spot))
            }
            
            success(true)
            return
        }
        
        locationShortCutButton.backgroundColor = R.color.accentColor()
        locationShortCutButton.image = R.image.pinIcon()
        
        return UISwipeActionsConfiguration(actions: [locationShortCutButton])
    }
}
