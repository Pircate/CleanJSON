// 
//  Adaptor.swift
//  CleanJSON
//
//  Created by Pircate(gao497868860@gmail.com) on 2018/12/13
//  Copyright © 2018 Pircate. All rights reserved.
//

public typealias AdaptorType<T> = (CleanDecoder) throws -> T

extension CleanJSONDecoder {
    
    public struct Adaptor {
        
        public var decodeBool: AdaptorType<Bool> = { _ in false }
        
        public var decodeInt: AdaptorType<Int> = { decoder in
            guard !decoder.decodeNull() else {
                return 0
            }
            
            guard let stringValue = try decoder.decode(String.self) else {
                return 0
            }
            
            return Int(stringValue) ?? 0
        }
        
        public var decodeUInt: AdaptorType<UInt> = { decoder in
            guard !decoder.decodeNull() else {
                return 0
            }
            
            guard let stringValue = try decoder.decode(String.self) else {
                return 0
            }
            
            return UInt(stringValue) ?? 0
        }
        
        public var decodeFloat: AdaptorType<Float> = { decoder in
            guard !decoder.decodeNull() else {
                return 0
            }
            
            guard let stringValue = try decoder.decode(String.self) else {
                return 0
            }
            
            return Float(stringValue) ?? 0
        }
        
        public var decodeDouble: AdaptorType<Double> = { decoder in
            guard !decoder.decodeNull() else {
                return 0
            }
            
            guard let stringValue = try decoder.decode(String.self) else {
                return 0
            }
            
            return Double(stringValue) ?? 0
        }
        
        public var decodeString: AdaptorType<String> = { decoder in
            guard !decoder.decodeNull() else {
                return ""
            }
            
            if let intValue = try decoder.decode(Int.self) {
                return String(intValue)
            } else if let doubleValue = try decoder.decode(Double.self) {
                return String(doubleValue)
            } else if let boolValue = try decoder.decode(Bool.self) {
                return String(boolValue)
            }
            
            return ""
        }
        
        public init() {}
    }
}
