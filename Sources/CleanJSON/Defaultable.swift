// 
//  Defaultable.swift
//  CleanJSON
//
//  Created by Pircate(swifter.dev@gmail.com) on 2018/12/14
//  Copyright © 2018 Pircate. All rights reserved.
//

import Foundation

protocol Defaultable {
    static var defaultValue: Self { get }
}

extension Bool: Defaultable {
    static var defaultValue: Bool {
        return false
    }
}

extension Int: Defaultable {
    static var defaultValue: Int {
        return 0
    }
}

extension Double: Defaultable {
    static var defaultValue: Double {
        return 0
    }
}

extension String: Defaultable {
    static var defaultValue: String {
        return ""
    }
}

extension Date: Defaultable {
    static var defaultValue: Date {
        return Date(timeIntervalSinceReferenceDate: 0)
    }
    
    static func defaultValue(for strategy: JSONDecoder.DateDecodingStrategy) -> Date {
        switch strategy {
        case .secondsSince1970, .millisecondsSince1970:
            return Date(timeIntervalSince1970: 0)
        default:
            return defaultValue
        }
    }
}

extension Data: Defaultable {
    static var defaultValue: Data {
        return Data()
    }
}

extension Decimal: Defaultable {
    static var defaultValue: Decimal {
        return Decimal(0)
    }
}
