//
//  AuthService.swift
//  Giftrip
//
//  Created by 강민석 on 2021/04/21.
//

import RxSwift
import KeychainAccess
import CryptoSwift

protocol AuthServiceType {
    var currentToken: Token? { get }
    
    func login(_ phoneNumber: String, _ password: String) -> Observable<Void>
    func register(_ phoneNumber: String, _ code: String, _ password: String, _ name: String, _ birth: Date) -> Observable<Void>
    func renewalToken()
    func logout()
    
    func createAuthCode(_ phoneNumber: String) -> Single<AuthCodeResponse>
}

final class AuthService: AuthServiceType {
    
    fileprivate let network: Network<AuthAPI>
    
    fileprivate let keychain = Keychain(service: Bundle.main.bundleIdentifier ?? "com.flash21.Giftrip")
    private(set) var currentToken: Token?
    
    let disposeBag = DisposeBag()
    
    init() {
        self.network = Network<AuthAPI>(plugins: [RequestLoggingPlugin()])
        self.currentToken = self.loadToken()
    }
    
    func login(_ phoneNumber: String, _ password: String) -> Observable<Void> {
        return network.requestObject(.login(phoneNumber, password.sha512()), type: Token.self)
            .asObservable()
            .do(onNext: { [weak self] response in
                try self?.saveToken(response)
                self?.currentToken = response
            })
            .map { _ in }
    }
    
    func register(_ phoneNumber: String, _ code: String, _ password: String, _ name: String, _ birth: Date) -> Observable<Void> {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        let date = dateFormatter.string(from: birth)
        
        return network.requestObject(.register(phoneNumber, code, password.sha512(), name, date), type: Token.self)
            .asObservable()
            .do(onNext: { [weak self] response in
                try self?.saveToken(response)
                self?.currentToken = response
            })
            .map { _ in }
    }
    
    func renewalToken() {
        let refreshToken = self.loadToken()?.refreshToken?.token
        return network.requestObject(.refresh(refreshToken ?? ""), type: Token.self)
            .subscribe(onSuccess: { [weak self] token in
                try? self?.saveToken(token)
                self?.currentToken = token
            }).disposed(by: disposeBag)
    }
    
    func logout() {
        self.currentToken = nil
        self.deleteToken()
    }
    
    func createAuthCode(_ phoneNumber: String) -> Single<AuthCodeResponse> {
        return network.requestObject(.createAuthCode(phoneNumber), type: AuthCodeResponse.self)
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
