//
//  GiftripAPI.swift
//  Giftrip
//
//  Created by 강민석 on 2021/04/21.
//

import RxSwift
import Moya

enum GiftripAPI {
    
    // MARK: - userController
    case changePw(_ password: String)
    case getMyInfo
    case editMyInfo(_ name: String)
    
}

extension GiftripAPI: BaseAPI {
    var path: String {
        switch self {
        case .changePw:
            return "/auth/changePw"
        case .getMyInfo:
            return "/user/getMyInfo"
        case .editMyInfo:
            return "/user/editMyInfo"
        }
    }
    
    var method: Moya.Method {
        switch self {
//        case :
//            return .post
            
        case .getMyInfo:
            return .get
            
        case .changePw, .editMyInfo:
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
        case let .changePw(password):
            return [
                "pw": password
            ]
            
        case let .editMyInfo(name):
            return [
                "name": name
            ]
            
        default:
            return nil
        }
    }
}
