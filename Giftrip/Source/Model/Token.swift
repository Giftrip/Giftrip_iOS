//
//  Token.swift
//  Giftrip
//
//  Created by 강민석 on 2021/04/20.
//

import Foundation

struct Token: ModelType {
    enum Event {}
    
    var accessToken: AccessToken
    var refreshToken: RefreshToken

    private enum CodingKeys: String, CodingKey {
        case accessToken
        case refreshToken
    }
}

struct AccessToken: Codable {
    var expiredAt: Date
    var token: String
    
    private enum CodingKeys: String, CodingKey {
        case expiredAt
        case token
    }
}

struct RefreshToken: Codable {
    var expiredAt: Date
    var token: String
    
    private enum CodingKeys: String, CodingKey {
        case expiredAt
        case token
    }
}
