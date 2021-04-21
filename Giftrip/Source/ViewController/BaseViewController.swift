//
//  BaseViewController.swift
//  Giftrip
//
//  Created by 강민석 on 2021/04/19.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {
    
    // MARK: - Properties
    let activityIndicatorView = UIActivityIndicatorView(style: .large)
    
    // MARK: - Initializing
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Rx
    var disposeBag = DisposeBag()
    
    // MARK: - View Lifecycle
    deinit {
        self.activityIndicatorView.stopAnimating()
    }
    
    // MARK: - Layout Constraints
    private(set) var didSetupConstraints = false
    
    override func viewDidLoad() {
        self.view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        if !self.didSetupConstraints {
            self.setupConstraints()
            self.didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
    
    func setupConstraints() {
        // default
        activityIndicatorView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
}
