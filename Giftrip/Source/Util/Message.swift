//
//  Message.swift
//  Giftrip
//
//  Created by 강민석 on 2021/05/06.
//

import SwiftMessages

class Message {
    
    static var bottomConfig: SwiftMessages.Config {
        var config = SwiftMessages.Config()
        config.presentationStyle = .bottom
        config.presentationContext = .window(windowLevel: .normal)
        config.duration = .automatic
        config.dimMode = .none
        config.interactiveHide = true
        config.preferredStatusBarStyle = .default
        return config
    }
    
    static var timerConfig: SwiftMessages.Config {
        var config = SwiftMessages.Config()
        config.presentationStyle = .top
        config.presentationContext = .window(windowLevel: .normal)
        config.duration = .forever
        config.dimMode = .none
        config.interactiveHide = true
        config.preferredStatusBarStyle = .default
        return config
    }
    
    static func successView(_ title: String) -> MessageView {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(.success)
        view.configureContent(title: title, body: "")
        view.button?.isHidden = true
        
        return view
    }
    
    static func faildView(_ title: String) -> MessageView {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(.error)
        view.configureContent(title: title, body: "")
        view.button?.isHidden = true
        
        return view
    }
    
    static func timerView(_ expireDate: Date) -> MessageView {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(.info)
        view.button?.isHidden = true
        
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var timeInterval = Int(expireDate.timeIntervalSince(Date()))
        view.configureContent(title: "인증번호 만료까지 초", body: "")
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            timeInterval -= 1
            view.configureContent(title: "인증번호 만료까지 \(timeInterval)초 ", body: "")
            if timeInterval <= 0 {
                timer.invalidate()
                SwiftMessages.hideAll()
            }
        }
        
        return view
    }
}
