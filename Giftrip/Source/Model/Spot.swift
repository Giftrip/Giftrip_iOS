//
//  Spot.swift
//  Giftrip
//
//  Created by 강민석 on 2021/06/07.
//

import Foundation

struct Spot: ModelType {
    enum Event { }
    
    var address: String
    var description: String
    var lon: Double
    var completed: Bool
    var idx: Int
    var courseIdx: Int
    var title: String
    var lat: Double
    var thumbnails: [URL]
    
    enum CodingKeys: String, CodingKey {
        case address
        case description
        case lon
        case completed
        case idx
        case courseIdx
        case title
        case lat
        case thumbnails
    }
}
