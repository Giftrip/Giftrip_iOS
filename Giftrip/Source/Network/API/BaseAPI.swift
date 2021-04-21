//
//  BaseAPI.swift
//  Giftrip
//
//  Created by 강민석 on 2021/04/19.
//

import Moya

protocol BaseAPI: TargetType {}

extension BaseAPI {
    var baseURL: URL { URL(string: "")! }
    
    var method: Method { .get }
    
    var sampleData: Data { Data() }
    
    var task: Task { .requestPlain }
    
    var headers: [String: String]? { nil }
}
