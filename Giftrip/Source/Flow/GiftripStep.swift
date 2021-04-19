//
//  GiftripStep.swift
//  Giftrip
//
//  Created by 강민석 on 2021/04/19.
//

import RxFlow

enum GiftripStep: Step {
    
    case splashViewIsRequired
    
    case introViewIsRequired
    case loginViewIsRequired
    case signupViewIsRequired
    
    case mainViewIsRequired
    
}
