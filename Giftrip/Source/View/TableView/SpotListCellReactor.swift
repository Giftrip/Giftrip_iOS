//
//  SpotListCellReactor.swift
//  Giftrip
//
//  Created by 강민석 on 2021/06/08.
//

import ReactorKit

final class SpotListCellReactor: Reactor {
    typealias Action = NoAction
    
    struct State {
        var address: String
        var description: String
        var completed: Bool
        var title: String
        var thumbnail: URL
    }
    
    var initialState: State
    let spot: Spot
    
    init(spot: Spot) {
        self.initialState = State(
            address: spot.address,
            description: spot.description,
            completed: spot.completed,
            title: spot.title,
            thumbnail: spot.thumbnails.first!
        )
        self.spot = spot
        _ = self.state
    }
}