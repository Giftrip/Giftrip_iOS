//
//  RefreshControl.swift
//  Giftrip
//
//  Created by 강민석 on 2021/06/08.
//

import UIKit

final class RefreshControl: UIRefreshControl {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
    }
    
    convenience override init() {
        self.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
