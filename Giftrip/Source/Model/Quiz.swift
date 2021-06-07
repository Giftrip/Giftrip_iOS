//
//  Quiz.swift
//  Giftrip
//
//  Created by 강민석 on 2021/06/07.
//

import Foundation

struct Quiz: ModelType {
    enum Event { }
    
    var quiz: String
    var youtube: URL
    
    enum CodingKeys: String, CodingKey {
        case quiz
        case youtube
    }
}
