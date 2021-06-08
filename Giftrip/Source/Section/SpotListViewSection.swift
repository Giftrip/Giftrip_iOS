//
//  SpotListViewSection.swift
//  Giftrip
//
//  Created by 강민석 on 2021/06/08.
//

import RxDataSources

enum SpotListViewSection {
    case spotSection([SpotListViewSectionItem])
}

extension SpotListViewSection: SectionModelType {
    typealias Item = SpotListViewSectionItem
    
    var items: [SpotListViewSectionItem] {
        switch self {
        case let .spotSection(items):
            return items
        }
    }
    
    init(original: SpotListViewSection, items: [SpotListViewSectionItem]) {
        switch original {
        case .spotSection:
            self = .spotSection(items)
        }
    }
}

enum SpotListViewSectionItem {
    case spotItem(SpotListCellReactor)
}
