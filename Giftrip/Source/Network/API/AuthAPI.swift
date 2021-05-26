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
    
    /// 비밀번호 인증 코드로 변경
    case changePwByCode(_ phoneNumber: String, _ code: String, _ password: String)
    
    /// 휴대폰 인증 생성
    case createAuthCode(_ phoneNumber: String)
    
    /// 비밀번호 변경 휴대폰 인증 생성 및 코드 조회
    case getPwAuthCode(_ phoneNumber: String)
    
    /// 로그인
    case login(_ phoneNumber: String, _ password: String)
    
    /// 토큰갱신
    case refresh(_ refreshToken: String)
    
    /// 회원가입
    case register(_ phoneNumber: String, _ code: String, _ password: String, _ name: String, _ birth: Date)
}

extension AuthAPI: BaseAPI {
    var path: String {
        switch self {
        case .changePwByCode:
            return "/auth/changePwByCode"
            
        case .createAuthCode:
            return "/auth/createAuthCode"
            
        case let .getPwAuthCode(phone):
            return "/auth/getPwAuthCode/\(phone)"
            
        case .login:
            return "/auth/login"
            
        case .refresh:
            return "/auth/refresh"
            
        case .register:
            return "/auth/register"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createAuthCode, .login, .refresh, .register:
            return .post
            
        case .getPwAuthCode:
            return .get
            
        case .changePwByCode:
            return .patch
        }
    }
    
    var headers: [String: String]? {
        return ["Accept": "application/json"]
    }
    
    var parameters: [String: Any]? {
        var params: [String: Any] = [:]
        switch self {
        case let .changePwByCode(phoneNumber, code, password):
            params["phoneNumber"] = phoneNumber
            params["code"] = code
            params["pw"] = password
            
        case let .createAuthCode(phoneNumber):
            params["phoneNumber"] = phoneNumber
            
        case let .login(phoneNumber, password):
            params["phoneNumber"] = phoneNumber
            params["pw"] = password
            
        case let .refresh(refreshToken):
            params["refreshToken"] = refreshToken
            
        case let .register(phoneNumber, code, password, name, birth):
            params["phoneNumber"] = phoneNumber
            params["code"] = code
            params["pw"] = password
            params["name"] = name
            params["birth"] = birth
            
        default: break
        }
        return params
    }
    
    public var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var task: Task {
        switch self {
        default:
            if let parameters = parameters {
                return .requestParameters(parameters: parameters, encoding: parameterEncoding)
            }
            return .requestPlain
        }
    }
}
