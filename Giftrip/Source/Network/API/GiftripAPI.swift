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
    case editMyInfo(_ name: String)
    case getMyInfo
    
    // MARK: - spotController
    case completeQuiz(_ idx: Int, _ answer: Bool, _ nfcCode: String)
    case getQuizByNfc(_ idx: Int, _ nfcCode: String)
    case getSpot(_ idx: Int)
    case getSpots(_ page: Int, _ size: Int, _ courseIdx: Int)
    
    // MARK: - noticeController
    case getNotice(_ idx: Int)
    case getNotices(_ page: Int, _ size: Int)
}

extension GiftripAPI: BaseAPI, AuthorizedTargetType {
    
    var needsAuth: Bool {
        switch self {
//        case .:
//            return false
        default:
            return true
        }
    }
    
    var path: String {
        switch self {
        case .changePw:
            return "/auth/changePw"
        case .getMyInfo:
            return "/user/getMyInfo"
        case .editMyInfo:
            return "/user/editMyInfo"
            
        case let .completeQuiz(idx, _, _):
            return "/spot/completeQuiz/\(idx)"
        case let .getQuizByNfc(idx, _):
            return "/spot/getQuizByNfc/\(idx)"
        case let .getSpot(idx):
            return "/spot/getSpot/\(idx)"
        case .getSpots:
            return "/spot/getSpots"
            
        case let .getNotice(idx):
            return "notice/getNotice/\(idx)"
        case .getNotices:
            return "notice/getNotices"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .completeQuiz:
            return .post
            
        case .changePw, .editMyInfo:
            return .patch
            
        default:
            return .get
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
    
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
            
        case let .completeQuiz(_, answer, nfcCode):
            return [
                "answer": answer,
                "nfcCode": nfcCode
            ]
            
        case let .getQuizByNfc(_, nfcCode):
            return [
                "nfcCode": nfcCode
            ]
            
        case let .getSpots(page, size, courseIdx):
            return [
                "page": page,
                "size": size,
                "courseIdx": courseIdx
            ]
            
        case let .getNotices(page, size):
            return [
                "page": page,
                "size": size
            ]
            
        default:
            return nil
        }
    }
    
    public var parameterEncoding: ParameterEncoding {
        switch self {
        case .getQuizByNfc, .getSpots, .getNotices:
            return URLEncoding.queryString
            
        default:
            return JSONEncoding.default
        }
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
