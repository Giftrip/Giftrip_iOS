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
    fileprivate let authService: AuthServiceType
    
    init(authService: AuthServiceType) {
        self.authService = authService
    }
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        guard
            var token = authService.currentToken,
            let target = target as? AuthorizedTargetType,
            target.needsAuth
        else {
            return request
        }
        
        if token.refreshToken!.expiredAt > Date() {
            authService.logout()
            return request // logout후 request 요청을 중단(취소)할 방법을 찾아야함
        } else if token.accessToken.expiredAt > Date() {
            authService.renewalToken()
            token = authService.currentToken!
        }
        
        var request = request
        request.addValue("Bearer \(token.accessToken.token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
