//
//  DIContainer.swift
//  Giftrip
//
//  Created by 강민석 on 2021/04/20.
//

import Kingfisher
import RxViewController
import RxOptional
import SnapKit
import Then

class AppServices {
    static let shared = AppServices()
    
    let authService: AuthServiceType
    let userService: UserServiceType
    
    private init() {
        self.authService = AuthService()
        
        let network = Network<GiftripAPI>(
            isHandleToken: true,
            plugins: [
                RequestLoggingPlugin(),
                AuthPlugin(authService: authService)
            ]
        )
        
        self.userService = UserService(network: network)
    }
}
