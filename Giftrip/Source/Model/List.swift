//
//  List.swift
//  Giftrip
//
//  Created by 강민석 on 2021/06/07.
//

import Foundation

struct List<T: Codable>: ModelType {
    enum Event { }
    
    var totalPage: Int
    var completed: Int?
    var content: [T]
    var totalElements: Int
    
    enum CodingKeys: String, CodingKey {
        case totalPage
        case completed
        case content
        case totalElements
    }
}
