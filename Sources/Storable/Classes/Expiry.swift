// 
//  Expiry.swift
//  Storable
//
//  Created by Pircate(swifter.dev@gmail.com) on 2019/4/22
//  Copyright © 2019年 Pircate. All rights reserved.
//

import Foundation

public enum Expiry {
    /// Object will be expired in the nearest future
    case never
    /// Object will be expired in the specified amount of seconds
    case seconds(TimeInterval)
    /// Object will be expired on the specified date
    case date(Date)
    
    /// Returns the appropriate date object
    public var date: Date {
        switch self {
        case .never:
            // Ref: http://lists.apple.com/archives/cocoa-dev/2005/Apr/msg01833.html
            return Date(timeIntervalSince1970: 60 * 60 * 24 * 365 * 68)
        case .seconds(let seconds):
            return Date().addingTimeInterval(seconds)
        case .date(let date):
            return date
        }
    }
    
    /// Checks if cached object is expired according to expiration date
    public var isExpired: Bool {
        return date.timeIntervalSinceNow < 0
    }
}

public extension Expiry {
    
    enum Error: Swift.Error {
        case noCache
        case expired(Date)
    }
}
