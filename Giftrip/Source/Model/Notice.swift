//
//  Notice.swift
//  Giftrip
//
//  Created by 강민석 on 2021/06/15.
//

import Foundation

struct Notice: ModelType {
    enum Event { }
    
    var createdAt: Date
    var thumbnail: URL
    var viewed: Bool
    var title: String
    var idx: Int
    var content: String
    
    enum CodingKeys: String, CodingKey {
        case createdAt
        case thumbnail
        case viewed
        case title
        case idx
        case content
    }
}
