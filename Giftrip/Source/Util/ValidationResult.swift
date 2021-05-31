//
//  ValidationResult.swift
//  Giftrip
//
//  Created by 강민석 on 2021/05/06.
//

import Foundation

extension String {
    var isNotEmpty: Bool {
        return !self.isEmpty
    }
    
    var isEmail: Bool {
        let EMAIL_REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", EMAIL_REGEX).evaluate(with: self)
    }
    
    var isPhone: Bool {
        let PHONE_REGEX = "^01([0|1|6|7|8|9]?)-?([0-9]{3,4})-?([0-9]{4})$"
        return NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX).evaluate(with: self)
    }
    
    var isName: Bool {
        let NAME_REGEX = "[가-힣A-Za-z0-9]{2,7}"
        return NSPredicate(format: "SELF MATCHES %@", NAME_REGEX).evaluate(with: self)
    }
}
