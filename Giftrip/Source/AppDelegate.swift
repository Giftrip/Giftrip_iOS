//
//  AppDelegate.swift
//  Giftrip
//
//  Created by 강민석 on 2021/04/19.
//

import UIKit
import RxSwift
import RxFlow

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let disposeBag = DisposeBag()
    var window: UIWindow?
    var coordinator = FlowCoordinator()
    let appServices = AppServices.shared
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = .systemBackground
        self.window?.makeKeyAndVisible()
        
        guard let window = self.window else { return false }
        
        coordinator.rx.willNavigate.subscribe(onNext: { (flow, step) in
            print("❇️ will navigate to flow=\(flow) and step=\(step)")
        }).disposed(by: self.disposeBag)
        
        coordinator.rx.didNavigate.subscribe(onNext: { (flow, step) in
            print("✅ did navigate to flow=\(flow) and step=\(step)")
        }).disposed(by: self.disposeBag)
        
        let appFlow = AppFlow(window: window, services: appServices)
        
        let nextStepper = OneStepper(withSingleStep: GiftripStep.splashIsRequired)
        self.coordinator.coordinate(flow: appFlow, with: nextStepper)
        
        return true
    }
}
