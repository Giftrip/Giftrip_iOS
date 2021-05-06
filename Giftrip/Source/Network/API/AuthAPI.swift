//
//  AuthAPI.swift
//  Giftrip
//
//  Created by 강민석 on 2021/04/24.
//

import RxSwift
import Moya

enum AuthAPI {
    
    // MARK: - authController
    case login(_ phoneNumber: String, _ password: String)
    case register(_ phoneNumber: String, _ code: String, _ password: String, _ name: String, _ birth: Date)
    case refresh(_ refreshToken: String)
    case changePwByCode(_ phoneNumber: String, _ code: String, _ password: String)
    case getAuthCode
    case getPwAuthCode
    
}

extension AuthAPI: BaseAPI {
    var path: String {
        switch self {
        case .login:
            return "/auth/login"
        case .register:
            return "/auth/register"
        case .refresh:
            return "/auth/refresh"
        case .changePwByCode:
            return "/auth/changePwByCode"
        case .getAuthCode:
            return "/auth/getAuthCode"
        case .getPwAuthCode:
            return "/auth/getPwAuthCode"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login, .refresh, .register:
            return .post
            
        case .getAuthCode, .getPwAuthCode:
            return .get
            
        case .changePwByCode:
            return .patch
        }
    }
    
    var headers: [String: String]? {
        return ["Accept": "application/json"]
    }
    
//    var task: Task {
//        switch self {
//        case :
//
//        }
//    }
    
    var parameters: [String: Any]? {
        switch self {
        case let .login(phoneNumber, password):
            return [
                "phoneNumber": phoneNumber,
                "pw": password
            ]
            
        case let .register(phoneNumber, code, password, name, birth):
            return [
                "phoneNumber": phoneNumber,
                "code": code,
                "pw": password,
                "name": name,
                "birth": birth
            ]
            
        case let .refresh(refreshToken):
            return [
                "refreshToken": refreshToken
            ]
            
        case let .changePwByCode(phoneNumber, code, password):
            return [
                "phoneNumber": phoneNumber,
                "code": code,
                "pw": password
            ]
            
        default:
            return nil
        }
    }
}
