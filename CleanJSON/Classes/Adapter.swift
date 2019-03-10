// 
//  Adapter.swift
//  CleanJSON
//
//  Created by Pircate(gao497868860@gmail.com) on 2018/12/13
//  Copyright © 2018 Pircate. All rights reserved.
//

public typealias AdapterType<T> = (CleanDecoder) throws -> T

extension CleanJSONDecoder {
    
    public struct Adapter {
        
        public var decodeBool: AdapterType<Bool> = { _ in Bool.defaultValue }
        
        public var decodeInt: AdapterType<Int> = { decoder in
            guard !decoder.decodeNull() else { return Int.defaultValue }
            
            guard let stringValue = try decoder.decodeIfPresent(String.self) else {
                return Int.defaultValue
            }
            
            return Int(stringValue) ?? Int.defaultValue
        }
        
        public var decodeUInt: AdapterType<UInt> = { decoder in
            guard !decoder.decodeNull() else { return UInt.defaultValue }
            
            guard let stringValue = try decoder.decodeIfPresent(String.self) else {
                return UInt.defaultValue
            }
            
            return UInt(stringValue) ?? UInt.defaultValue
        }
        
        public var decodeFloat: AdapterType<Float> = { decoder in
            guard !decoder.decodeNull() else { return Float.defaultValue }
            
            guard let stringValue = try decoder.decodeIfPresent(String.self) else {
                return Float.defaultValue
            }
            
            return Float(stringValue) ?? Float.defaultValue
        }
        
        public var decodeDouble: AdapterType<Double> = { decoder in
            guard !decoder.decodeNull() else { return Double.defaultValue }
            
            guard let stringValue = try decoder.decodeIfPresent(String.self) else {
                return Double.defaultValue
            }
            
            return Double(stringValue) ?? Double.defaultValue
        }
        
        public var decodeString: AdapterType<String> = { decoder in
            guard !decoder.decodeNull() else { return String.defaultValue }
            
            if let intValue = try decoder.decodeIfPresent(Int.self) {
                return String(intValue)
            } else if let doubleValue = try decoder.decodeIfPresent(Double.self) {
                return String(doubleValue)
            } else if let boolValue = try decoder.decodeIfPresent(Bool.self) {
                return String(boolValue)
            }
            
            return String.defaultValue
        }
        
        public init() {}
    }
}
