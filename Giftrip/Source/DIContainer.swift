//
//  DIContainer.swift
//  Giftrip
//
//  Created by 강민석 on 2021/04/20.
//

import Swinject
import SnapKit
import Then

class DIContainer {
    
    static let shared = DIContainer()
    
    let container: Container
    
    fileprivate init() {
        self.container = Container()
        
        self.register()
    }
    
    func register() {
        // Service 등록
        
        // ViewController 등록
        self.container.register(SplashViewController.self) { resolver in
            let reactor = SplashViewReactor()
            let controller = SplashViewController(reactor: reactor)
            
            return controller
        }
        
//        self.container.register(<#T##serviceType: Service.Type##Service.Type#>, factory: <#T##(Resolver) -> Service#>)
    }
}
