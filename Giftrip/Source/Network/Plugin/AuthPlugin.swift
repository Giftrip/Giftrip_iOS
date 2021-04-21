//
//  AuthPlugin.swift
//  Giftrip
//
//  Created by 강민석 on 2021/04/19.
//

import Moya

protocol AuthorizedTargetType: TargetType {
    var needsAuth: Bool { get }
}

struct AuthPlugin: PluginType {
    fileprivate let authService: AuthService
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        guard
            let token = authService.currentAccessToken?.token,
            let target = target as? AuthorizedTargetType,
            target.needsAuth
        else {
            return request
        }
        
        var request = request
        request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        return request
    }
}
