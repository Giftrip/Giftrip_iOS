//
//  ResponseData.swift
//  Giftrip
//
//  Created by 강민석 on 2021/04/21.
//

import Foundation

struct LoginResponse: Codable {
    var token: Token
    var user: User
    
    enum CodingKeys: String, CodingKey {
        case token
        case user = "info"
    }
}
