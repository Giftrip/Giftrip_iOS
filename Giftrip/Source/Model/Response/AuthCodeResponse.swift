//
//  AuthCodeResponse.swift
//  Giftrip
//
//  Created by 강민석 on 2021/05/26.
//

import Foundation

struct AuthCodeResponse: ModelType, Equatable {
    enum Event { }
    
    var retryAt: Date
    var expireAt: Date
    
    enum CodingKeys: String, CodingKey {
        case retryAt
        case expireAt
    }
}
