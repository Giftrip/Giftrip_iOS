//
//  BaseModel.swift
//  Giftrip
//
//  Created by 강민석 on 2021/04/20.
//

import Foundation

struct BaseModel<T: ModelType>: Codable {
    var data: T
    var message: String
    var status: Int
    
    enum CodingKeys: String, CodingKey {
        case data
        case message
        case status
    }
}
