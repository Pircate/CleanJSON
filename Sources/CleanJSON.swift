//
//  CleanJSON.swift
//  CleanJSON
//
//  Created by GorXion on 2018/5/3.
//

import Foundation

public extension KeyedDecodingContainer {
    
    public func decode(_ type: Bool.Type, forKey key: KeyedDecodingContainer.Key) throws -> Bool {
        
        guard contains(key) else { return false }
        
        let decoder = try superDecoder(forKey: key)
        
        if let value = try? type.init(from: decoder) {
            return value
        }
        return false
    }
    
    public func decode(_ type: String.Type, forKey key: KeyedDecodingContainer.Key) throws -> String {
        
        guard contains(key) else { return "" }
        
        let decoder = try superDecoder(forKey: key)
        
        if let value = try? type.init(from: decoder) {
            return value
        } else if let intValue = try? Int(from: decoder) {
            return String(intValue)
        } else if let doubleValue = try? Double(from: decoder) {
            return String(doubleValue)
        } else if let boolValue = try? Bool(from: decoder) {
            return String(boolValue)
        }
        return ""
    }
    
    public func decode(_ type: Double.Type, forKey key: KeyedDecodingContainer.Key) throws -> Double {
        
        guard contains(key) else { return 0.0 }
        
        let decoder = try superDecoder(forKey: key)
        
        if let value = try? type.init(from: decoder) {
            return value
        } else if let stringValue = try? String(from: decoder) {
            return Double(stringValue) ?? 0.0
        }
        return 0.0
    }
    
    public func decode(_ type: Float.Type, forKey key: KeyedDecodingContainer.Key) throws -> Float {
        
        guard contains(key) else { return 0.0 }
        
        let decoder = try superDecoder(forKey: key)
        
        if let value = try? type.init(from: decoder) {
            return value
        } else if let stringValue = try? String(from: decoder) {
            return Float(stringValue) ?? 0.0
        }
        return 0.0
    }
    
    public func decode(_ type: Int.Type, forKey key: KeyedDecodingContainer.Key) throws -> Int {
        
        guard contains(key) else { return 0 }
        
        let decoder = try superDecoder(forKey: key)
        
        if let value = try? type.init(from: decoder) {
            return value
        } else if let stringValue = try? String(from: decoder) {
            return Int(stringValue) ?? 0
        }
        return 0
    }
    
    public func decode(_ type: UInt.Type, forKey key: KeyedDecodingContainer.Key) throws -> UInt {
        
        guard contains(key) else { return 0 }
        
        let decoder = try superDecoder(forKey: key)
        
        if let value = try? type.init(from: decoder) {
            return value
        } else if let stringValue = try? String(from: decoder) {
            return UInt(stringValue) ?? 0
        }
        return 0
    }
    
    public func decode<T>(_ type: T.Type, forKey key: KeyedDecodingContainer.Key) throws -> T where T : Decodable {
        
        guard contains(key) else {
            if let objectValue = try? JSONDecoder().decode(type, from: "{}".data(using: .utf8)!) {
                return objectValue
            } else if let arrayValue = try? JSONDecoder().decode(type, from: "[]".data(using: .utf8)!) {
                return arrayValue
            }
            let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Key: <\(key.stringValue)> not found")
            throw DecodingError.keyNotFound(key, context)
        }
        
        let decoder = try superDecoder(forKey: key)
        
        if let value = try? type.init(from: decoder) {
            return value
        } else if let objectValue = try? JSONDecoder().decode(type, from: "{}".data(using: .utf8)!) {
            return objectValue
        } else if let arrayValue = try? JSONDecoder().decode(type, from: "[]".data(using: .utf8)!) {
            return arrayValue
        }
        throw DecodingError.dataCorruptedError(forKey: key, in: self, debugDescription: "Key: <\(key.stringValue)> cannot be decoded")
    }
}
