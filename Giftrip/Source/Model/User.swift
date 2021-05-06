//
//  User.swift
//  Giftrip
//
//  Created by 강민석 on 2021/04/21.
//

import Foundation

struct User: ModelType {
    enum Event {}
    
    var idx: Int
    var name: String
    var phoneNumber: String
    var birth: Date
    
    var isAdmin: Bool
    
    var createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case idx
        case name
        case phoneNumber
        case birth
        case isAdmin
        case createdAt
    }
}
