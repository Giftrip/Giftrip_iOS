//
//  AuthService.swift
//  Giftrip
//
//  Created by 강민석 on 2021/04/21.
//

import RxSwift
import KeychainAccess

protocol AuthServiceType {
    
    
}

final class AuthService: Network<GiftripAPI>, AuthServiceType {
    
    fileprivate let keychain = Keychain(service: "com.flash21.Giftrip")
    private(set) var currentAccessToken: AccessToken?
    
    func login() {
        
    }
    
    func signup() {
        
    }
    
    func logout() {
        
    }
    
    
    
}
