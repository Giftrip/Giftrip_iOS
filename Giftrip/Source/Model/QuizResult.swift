//
//  QuizResult.swift
//  Giftrip
//
//  Created by 강민석 on 2021/06/07.
//

import Foundation

struct QuizResult: ModelType {
    enum Event { }
    
    var solved: Bool
    var courseCompleted: Bool
    var explanation: String
    
    enum CodingKeys: String, CodingKey {
        case solved
        case courseCompleted
        case explanation
    }
}
