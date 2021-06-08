//
//  UIScrollView+ScrollToBottom.swift
//  Giftrip
//
//  Created by 강민석 on 2021/06/08.
//

import UIKit

extension UIScrollView {
    var isOverflowVertical: Bool {
        return self.contentSize.height > self.bounds.height && self.bounds.height > 0
    }
    
    func isReachedBottom(withTolerance tolerance: CGFloat = 0) -> Bool {
        guard self.isOverflowVertical else { return false }
        let contentOffsetBottom = self.contentOffset.y + self.bounds.height
        return contentOffsetBottom >= self.contentSize.height - tolerance
    }
    
    func scrollToBottom(animated: Bool) {
        guard self.isOverflowVertical else { return }
        let targetY = self.contentSize.height + self.contentInset.bottom - self.bounds.height
        let targetOffset = CGPoint(x: 0, y: targetY)
        self.setContentOffset(targetOffset, animated: true)
    }
}
