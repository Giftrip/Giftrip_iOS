//
//  SpotListViewReactor.swift
//  Giftrip
//
//  Created by 강민석 on 2021/05/31.
//

import ReactorKit
import RxCocoa
import RxSwift
import RxFlow

final class SpotListViewReactor: Reactor, Stepper {

    var steps = PublishRelay<Step>()

    enum Action {
        case refresh
        case loadMore
        case swipeSpot(Spot)
        case spotSelected(Spot)
    }

    enum Mutation {
        case setSpots([Spot])
        case appendShots([Spot])
        case setLoading(Bool)
    }

    struct State {
        var section: [SpotListViewSection] = [.spotSection([])]
        
        var page: Int = 0
        var isLoading: Bool = false
    }

    let initialState: State = State()
    fileprivate let spotService: SpotServiceType

    init(
        spotService: SpotServiceType
    ) {
        self.spotService = spotService
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return .concat([
                Observable.just(Mutation.setLoading(true)),
                self.spotService.getSpots(1, 20, 1)
                    .asObservable()
                    .map { list -> Mutation in
                        return .setSpots(list.content)
                    },
                Observable.just(Mutation.setLoading(false))
            ])
            
        case .loadMore:
            return .concat([
                Observable.just(Mutation.setLoading(true)),
                self.spotService.getSpots(self.currentState.page, 15, 1)
                    .asObservable()
                    .map { list -> Mutation in
                        return .appendShots(list.content)
                    },
                Observable.just(Mutation.setLoading(false))
            ])
        case let .spotSelected(spot):
            self.steps.accept(GiftripStep.spotDetailIsRequired(idx: spot.idx))
            return .empty()
            
        case let .swipeSpot(spot):
            setLocation.onNext(spot)
            return .empty()
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state

        switch mutation {
        case let .setLoading(isLoading):
            state.isLoading = isLoading
            
        case let .setSpots(spots):
            let sectionItems = self.spotSectionItems(with: spots)
            state.section = [.spotSection(sectionItems)]
            state.page = 2
            
        case let .appendShots(spots):
            let sectionItems = state.section[0].items + self.spotSectionItems(with: spots)
            state.section = [.spotSection(sectionItems)]
            state.page += 1
        }

        return state
    }
    
    private func spotSectionItems(with spots: [Spot]) -> [SpotListViewSectionItem] {
        var sectionItems = [SpotListViewSectionItem]()
        
        spots.forEach { spot in
            sectionItems.append(.spotItem(SpotListCellReactor(spot: spot)))
        }
        
        return sectionItems
    }
}
