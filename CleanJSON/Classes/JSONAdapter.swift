// 
//  JSONAdapter.swift
//  CleanJSON
//
//  Created by Pircate(swifter.dev@gmail.com) on 2018/12/13
//  Copyright © 2018 Pircate. All rights reserved.
//

public protocol JSONAdapter {
    
    func adapt(_ decoder: CleanDecoder) throws -> Bool
    
    func adapt(_ decoder: CleanDecoder) throws -> Int
    
    func adapt(_ decoder: CleanDecoder) throws -> Int8
    
    func adapt(_ decoder: CleanDecoder) throws -> Int16
    
    func adapt(_ decoder: CleanDecoder) throws -> Int32
    
    func adapt(_ decoder: CleanDecoder) throws -> Int64
    
    func adapt(_ decoder: CleanDecoder) throws -> UInt
    
    func adapt(_ decoder: CleanDecoder) throws -> UInt8
    
    func adapt(_ decoder: CleanDecoder) throws -> UInt16
    
    func adapt(_ decoder: CleanDecoder) throws -> UInt32
    
    func adapt(_ decoder: CleanDecoder) throws -> UInt64
    
    func adapt(_ decoder: CleanDecoder) throws -> Float
    
    func adapt(_ decoder: CleanDecoder) throws -> Double
    
    func adapt(_ decoder: CleanDecoder) throws -> String
    
    func adapt(_ decoder: CleanDecoder) throws -> Date
    
    func adapt(_ decoder: CleanDecoder) throws -> Decimal
}

public extension JSONAdapter {
    
    func adapt(_ decoder: CleanDecoder) throws -> Bool {
        return Bool.defaultValue
    }
    
    func adapt(_ decoder: CleanDecoder) throws -> Int {
        guard !decoder.decodeNil() else { return Int.defaultValue }
        
        guard let stringValue = try decoder.decodeIfPresent(String.self) else {
            return Int.defaultValue
        }
        
        return Int(stringValue) ?? Int.defaultValue
    }
    
    func adapt(_ decoder: CleanDecoder) throws -> Int8 {
        return Int8.defaultValue
    }
    
    func adapt(_ decoder: CleanDecoder) throws -> Int16 {
        return Int16.defaultValue
    }
    
    func adapt(_ decoder: CleanDecoder) throws -> Int32 {
        return Int32.defaultValue
    }
    
    func adapt(_ decoder: CleanDecoder) throws -> Int64 {
        return Int64.defaultValue
    }
    
    func adapt(_ decoder: CleanDecoder) throws -> UInt {
        guard !decoder.decodeNil() else { return UInt.defaultValue }
        
        guard let stringValue = try decoder.decodeIfPresent(String.self) else {
            return UInt.defaultValue
        }
        
        return UInt(stringValue) ?? UInt.defaultValue
    }
    
    func adapt(_ decoder: CleanDecoder) throws -> UInt8 {
        return UInt8.defaultValue
    }
    
    func adapt(_ decoder: CleanDecoder) throws -> UInt16 {
        return UInt16.defaultValue
    }
    
    func adapt(_ decoder: CleanDecoder) throws -> UInt32 {
        return UInt32.defaultValue
    }
    
    func adapt(_ decoder: CleanDecoder) throws -> UInt64 {
        return UInt64.defaultValue
    }
    
    func adapt(_ decoder: CleanDecoder) throws -> Float {
        guard !decoder.decodeNil() else { return Float.defaultValue }
        
        guard let stringValue = try decoder.decodeIfPresent(String.self) else {
            return Float.defaultValue
        }
        
        return Float(stringValue) ?? Float.defaultValue
    }
    
    func adapt(_ decoder: CleanDecoder) throws -> Double {
        guard !decoder.decodeNil() else { return Double.defaultValue }
        
        guard let stringValue = try decoder.decodeIfPresent(String.self) else {
            return Double.defaultValue
        }
        
        return Double(stringValue) ?? Double.defaultValue
    }
    
    func adapt(_ decoder: CleanDecoder) throws -> String {
        guard !decoder.decodeNil() else { return String.defaultValue }
        
        if let intValue = try decoder.decodeIfPresent(Int.self) {
            return String(intValue)
        } else if let doubleValue = try decoder.decodeIfPresent(Double.self) {
            return String(doubleValue)
        } else if let boolValue = try decoder.decodeIfPresent(Bool.self) {
            return String(boolValue)
        }
        
        return String.defaultValue
    }
    
    func adapt(_ decoder: CleanDecoder) throws -> Date {
        return Date.defaultValue
    }
    
    func adapt(_ decoder: CleanDecoder) throws -> Decimal {
        return Decimal.defaultValue
    }
}

extension CleanJSONDecoder {
    
    struct Adapter: JSONAdapter {}
}
