//
//  SpotService.swift
//  Giftrip
//
//  Created by 강민석 on 2021/06/07.
//

import RxSwift

protocol SpotServiceType {
    func completeQuiz(_ idx: Int, _ answer: Bool, _ nfcCode: String) -> Single<QuizResult>
    
    func getQuizByNfc(_ idx: Int, _ nfcCode: String) -> Single<Quiz>
    
    func getSpot(_ idx: Int) -> Single<Spot>
    
    func getSpots(_ page: Int, _ size: Int, _ courseIdx: Int) -> Single<List<Spot>>
}

final class SpotService: SpotServiceType {
    fileprivate let network: Network<GiftripAPI>
    
    init(network: Network<GiftripAPI>) {
        self.network = network
    }
        
    func completeQuiz(_ idx: Int, _ answer: Bool, _ nfcCode: String) -> Single<QuizResult> {
        return network.requestObject(.completeQuiz(idx, answer, nfcCode), type: QuizResult.self)
    }
    
    func getQuizByNfc(_ idx: Int, _ nfcCode: String) -> Single<Quiz> {
        return network.requestObject(.getQuizByNfc(idx, nfcCode), type: Quiz.self)
    }
    
    func getSpot(_ idx: Int) -> Single<Spot> {
        return network.requestObject(.getSpot(idx), type: Spot.self)
    }
    
    func getSpots(_ page: Int, _ size: Int, _ courseIdx: Int) -> Single<List<Spot>> {
        return network.requestObject(.getSpots(page, size, courseIdx), type: List.self)
    }
}
