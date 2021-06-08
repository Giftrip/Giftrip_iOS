//
//  UIScrollView+Rx.swift
//  Giftrip
//
//  Created by 강민석 on 2021/06/08.
//

import RxCocoa
import RxSwift

extension Reactive where Base: UIScrollView {
    var isReachedBottom: ControlEvent<Void> {
        let source = self.contentOffset
            .filter { [weak base = self.base] offset in
                guard let base = base else { return false }
                return base.isReachedBottom(withTolerance: base.bounds.height / 2)
            }
            .map { _ in Void() }
        return ControlEvent(events: source)
    }
}
