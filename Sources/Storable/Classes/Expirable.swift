// 
//  Expirable.swift
//  Storable
//
//  Created by Pircate(swifter.dev@gmail.com) on 2019/4/22
//  Copyright © 2019年 Pircate. All rights reserved.
//

import Foundation

public protocol Expirable {
    
    /// 缓存过期的时间
    var expiry: Expiry { get }
}

public extension Expirable {
    
    func update(expiry: Expiry, for key: StoringKey) {
        UserDefaults.standard.update(expiry: expiry.date, for: key.stringValue)
    }
    
    func removeExpiry(for key: StoringKey) {
        UserDefaults.standard.removeExpiryDate(for: key.stringValue)
    }
    
    func expiry(for key: StoringKey) throws -> Expiry {
        guard let date = UserDefaults.standard.expiryDate(for: key.stringValue) else {
            throw Expiry.Error.noCache
        }
        
        return .date(date)
    }
}

private extension UserDefaults {
    
    static let expiryKey = "com.pircate.github.expiry.key"
    
    func expiryDate(for key: String) -> Date? {
        guard let object = object(forKey: UserDefaults.expiryKey) as? [String: Date] else { return nil }
        
        return object[key]
    }
    
    func update(expiry date: Date, for key: String) {
        guard var object = object(forKey: UserDefaults.expiryKey) as? [String: Date] else {
            set([key: date], forKey: UserDefaults.expiryKey)
            return
        }
        
        object.updateValue(date, forKey: key)
        set(object, forKey: UserDefaults.expiryKey)
    }
    
    func removeExpiryDate(for key: String) {
        guard var object = object(forKey: UserDefaults.expiryKey) as? [String: Date] else {
            return
        }
        
        object.removeValue(forKey: key)
        set(object, forKey: UserDefaults.expiryKey)
    }
}
