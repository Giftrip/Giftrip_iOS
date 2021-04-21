//
//  GiftripAPI.swift
//  Giftrip
//
//  Created by 강민석 on 2021/04/21.
//

import RxSwift
import Moya

enum GiftripAPI {
    
    case login
    case signup
    
}

extension GiftripAPI: BaseAPI {
    var path: String {
        
    }
    
    var method: Method {
        
    }
    
    var headers: [String : String]? {
        
    }
    
    var task: Task {
        
    }
    
    var parameters: [String: Any]? {
        var params: [String: Any] = [:]
    }
}
