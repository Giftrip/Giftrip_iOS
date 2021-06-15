//
//  ErrorResponse.swift
//  Giftrip
//
//  Created by 강민석 on 2021/05/26.
//

import Foundation

struct ErrorResponse: Decodable, Error, Equatable {
    var message: String
    
    enum CodingKeys: String, CodingKey {
        case message
    }
}
