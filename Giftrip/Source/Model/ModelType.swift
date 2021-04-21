//
//  ModelType.swift
//  Giftrip
//
//  Created by 강민석 on 2021/04/20.
//

import Then

protocol ModelType: Codable, Then {
    associatedtype Event
    
    static var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy { get }
}

extension ModelType {
    static var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy {
        return .iso8601
    }
    
    static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = self.dateDecodingStrategy
        return decoder
    }
}
