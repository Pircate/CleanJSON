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
        let container = try decoder.singleValueContainer()
        
        if let value = try? container.decode(type) {
            return value
        }
        return false
    }
    
    public func decode(_ type: String.Type, forKey key: KeyedDecodingContainer.Key) throws -> String {
        
        guard contains(key) else { return "" }
        
        let decoder = try superDecoder(forKey: key)
        let container = try decoder.singleValueContainer()
        
        if let value = try? container.decode(type) {
            return value
        } else if let intValue = try? container.decode(Int.self) {
            return String(intValue)
        } else if let doubleValue = try? container.decode(Double.self) {
            return String(doubleValue)
        } else if let boolValue = try? container.decode(Bool.self) {
            return String(boolValue)
        }
        return ""
    }
    
    public func decode(_ type: Double.Type, forKey key: KeyedDecodingContainer.Key) throws -> Double {
        
        guard contains(key) else { return 0.0 }
        
        let decoder = try superDecoder(forKey: key)
        let container = try decoder.singleValueContainer()
        
        if let value = try? container.decode(type) {
            return value
        } else if let stringValue = try? container.decode(String.self) {
            return Double(stringValue) ?? 0.0
        }
        return 0.0
    }
    
    public func decode(_ type: Float.Type, forKey key: KeyedDecodingContainer.Key) throws -> Float {
        
        guard contains(key) else { return 0.0 }
        
        let decoder = try superDecoder(forKey: key)
        let container = try decoder.singleValueContainer()
        
        if let value = try? container.decode(type) {
            return value
        } else if let stringValue = try? container.decode(String.self) {
            return Float(stringValue) ?? 0.0
        }
        return 0.0
    }
    
    public func decode(_ type: Int.Type, forKey key: KeyedDecodingContainer.Key) throws -> Int {
        
        guard contains(key) else { return 0 }
        
        let decoder = try superDecoder(forKey: key)
        let container = try decoder.singleValueContainer()
        
        if let value = try? container.decode(type) {
            return value
        } else if let stringValue = try? container.decode(String.self) {
            return Int(stringValue) ?? 0
        }
        return 0
    }
    
    public func decode(_ type: UInt.Type, forKey key: KeyedDecodingContainer.Key) throws -> UInt {
        
        guard contains(key) else { return 0 }
        
        let decoder = try superDecoder(forKey: key)
        let container = try decoder.singleValueContainer()
        
        if let value = try? container.decode(type) {
            return value
        } else if let stringValue = try? container.decode(String.self) {
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
        let container = try decoder.singleValueContainer()
        
        if let value = try? container.decode(type) {
            return value
        } else if let objectValue = try? JSONDecoder().decode(type, from: "{}".data(using: .utf8)!) {
            return objectValue
        } else if let arrayValue = try? JSONDecoder().decode(type, from: "[]".data(using: .utf8)!) {
            return arrayValue
        }
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Key: <\(key.stringValue)> cannot be decoded")
    }
    
    public func decodeIfPresent(_ type: Bool.Type, forKey key: K) throws -> Bool? {
        return try decode(type, forKey: key)
    }
    
    public func decodeIfPresent(_ type: String.Type, forKey key: K) throws -> String? {
        return try decode(type, forKey: key)
    }
    
    public func decodeIfPresent(_ type: Double.Type, forKey key: K) throws -> Double? {
        return try decode(type, forKey: key)
    }
    
    public func decodeIfPresent(_ type: Float.Type, forKey key: K) throws -> Float? {
        return try decode(type, forKey: key)
    }
    
    public func decodeIfPresent(_ type: Int.Type, forKey key: K) throws -> Int? {
        return try decode(type, forKey: key)
    }
    
    public func decodeIfPresent(_ type: UInt.Type, forKey key: K) throws -> UInt? {
        return try decode(type, forKey: key)
    }
    
    public func decodeIfPresent<T>(_ type: T.Type, forKey key: K) throws -> T? where T : Decodable {
        return try decode(type, forKey: key)
    }
}
