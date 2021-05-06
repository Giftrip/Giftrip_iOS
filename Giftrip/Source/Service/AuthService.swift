//
//  AuthService.swift
//  Giftrip
//
//  Created by 강민석 on 2021/04/21.
//

import RxSwift
import KeychainAccess

protocol AuthServiceType {
    var currentToken: Token? { get }
    
    func login(phoneNumber: String, password: String) -> Observable<Void>
    func register(phoneNumber: String, code: String, password: String, name: String, birth: Date) -> Observable<Void>
    func logout()
}

final class AuthService: AuthServiceType {
    
    fileprivate let network: Network<AuthAPI> // 테스트 후 Alamofire로 대체할지 결정할 예정
    
    fileprivate let keychain = Keychain(service: "com.flash21.Giftrip")
    private(set) var currentToken: Token?
    
    init() {
        self.network = Network<AuthAPI>(plugins: [RequestLoggingPlugin()])
        self.currentToken = self.loadToken()
    }
    
    func login(phoneNumber: String, password: String) -> Observable<Void> {
        return network.requestObject(.login(phoneNumber, password), type: ResponseModel<Token>.self)
            .asObservable()
            .do(onNext: { [weak self] response in
                try self?.saveToken(response.data!)
                self?.currentToken = response.data
            })
            .map { _ in }
    }
    
    func register(phoneNumber: String, code: String, password: String, name: String, birth: Date) -> Observable<Void> {
        return network.requestObject(.register(phoneNumber, code, password, name, birth), type: ResponseModel<Token>.self)
            .asObservable()
            .do(onNext: { [weak self] response in
                try self?.saveToken(response.data!)
                self?.currentToken = response.data
            })
            .map { _ in }
    }
    
    @discardableResult
    func renewalToken() -> Observable<Void> {
        let refreshToken = self.loadToken()?.refreshToken?.token
        return network.requestObject(.refresh(refreshToken ?? ""), type: ResponseModel<Token>.self)
            .asObservable()
            .do(onNext: { [weak self] response in
                try self?.saveToken(response.data!)
                self?.currentToken = response.data
            })
            .map { _ in }
    }
    
    func logout() {
        self.currentToken = nil
        self.deleteToken()
    }
    
    fileprivate func saveToken(_ token: Token) throws {
        let jsonEncoder: JSONEncoder = JSONEncoder()
        
        let accessTokenData = try jsonEncoder.encode(token.accessToken)
        let accessToken = String(data: accessTokenData, encoding: .utf8)
        try self.keychain.set(accessToken ?? "", key: "access_token")
        
        if let refreshToken = token.refreshToken {
            let refreshTokenData = try jsonEncoder.encode(refreshToken)
            let refreshToken = String(data: refreshTokenData, encoding: .utf8)
            try self.keychain.set(refreshToken ?? "", key: "refresh_token")
        }
    }
    
    fileprivate func loadToken() -> Token? {
        let jsonDecoder: JSONDecoder = JSONDecoder()
        
        guard let accessTokenData = self.keychain["access_token"]?.data(using: .utf8),
              let refreshTokenData = self.keychain["refresh_token"]?.data(using: .utf8),
              let accessToken = try? jsonDecoder.decode(AccessToken.self, from: accessTokenData),
              let refreshToken = try? jsonDecoder.decode(RefreshToken.self, from: refreshTokenData)
        else { return nil }
        
        return Token(accessToken: accessToken, refreshToken: refreshToken)
    }
    
    fileprivate func deleteToken() {
        try? self.keychain.remove("access_token")
        try? self.keychain.remove("refresh_token")
    }
}
