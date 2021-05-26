//
//  GiftripStep.swift
//  Giftrip
//
//  Created by 강민석 on 2021/04/19.
//

import RxFlow

import RxFlow

enum GiftripStep: Step {
    
    case popViewController
    case dismiss
    
    // MARK: - Splash
    case splashIsRequired
    case mainTabBarIsRequired
    
    // MARK: - Intro
    case introIsRequired
    case privacyPolicyIsRequired
    case loginIsRequired
    case registerPhoneIsRequired
    case registerInfoIsRequired
    
    // MARK: - Home
    case homeIsRequired
    
    // MARK: - Rank
    case rankIsRequired
    
    // MARK: - Gift
    case giftIsRequired
    
    // MARK: - Notification
    case notificationIsRequired
    
    // MARK: - Settings
    case settingsIsRequired
}
