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
            let token = authService.currentToken,
            let target = target as? AuthorizedTargetType,
            target.needsAuth
        else {
            return request
        }
        
        var request = request
        request.addValue("Bearer \(token.accessToken.token)", forHTTPHeaderField: "Authorization")
        return request
    }
}

extension MoyaProvider {
    static func endpointResolver() -> MoyaProvider<Target>.RequestClosure {
        return { (endpoint, closure) in
            let request = try! endpoint.urlRequest()
            
            let service = AppServices.shared.authService
            let token = service.currentToken
            
            if token!.refreshToken!.expiredAt < Date() {
                service.logout()
                
                closure(.failure(MoyaError.statusCode(.init(statusCode: 410, data: Data()))))
                return
            }
            
            if token!.accessToken.expiredAt < Date() {
                let provider = MoyaProvider<AuthAPI>(plugins: [RequestLoggingPlugin()])
                
                provider.request(.refresh(token!.refreshToken!.token)) { result in
                    switch result {
                    case .success(let response):
                        do {
                            let decoder = JSONDecoder()
                            decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                            let token = try decoder.decode(Token.self, from: response.data)
                            try service.saveToken(token)

                            closure(.success(request))
                        } catch let error {
                            closure(.failure(MoyaError.encodableMapping(error)))
                        }

                    case .failure(let error):
                        closure(.failure(error))
                    }
                }
                return
            }
            
            closure(.success(request))
        }
    }
}
