// 
//  Adaptor.swift
//  CleanJSON
//
//  Created by Pircate(gao497868860@gmail.com) on 2018/12/13
//  Copyright © 2018 Pircate. All rights reserved.
//

extension CleanJSONDecoder {
    
    public struct Adaptor {
        
        public var decodeBool: (CleanDecoder) throws -> Bool = { _ in false }
        
        public var decodeInt: (CleanDecoder) throws -> Int = { decoder in
            guard !decoder.decodeNull() else {
                return 0
            }
            
            guard let stringValue = try decoder.decode(String.self) else {
                return 0
            }
            
            return Int(stringValue) ?? 0
        }
        
        public var decodeUInt: (CleanDecoder) throws -> UInt = { decoder in
            guard !decoder.decodeNull() else {
                return 0
            }
            
            guard let stringValue = try decoder.decode(String.self) else {
                return 0
            }
            
            return UInt(stringValue) ?? 0
        }
        
        public var decodeFloat: (CleanDecoder) throws -> Float = { decoder in
            guard !decoder.decodeNull() else {
                return 0
            }
            
            guard let stringValue = try decoder.decode(String.self) else {
                return 0
            }
            
            return Float(stringValue) ?? 0
        }
        
        public var decodeDouble: (CleanDecoder) throws -> Double = { decoder in
            guard !decoder.decodeNull() else {
                return 0
            }
            
            guard let stringValue = try decoder.decode(String.self) else {
                return 0
            }
            
            return Double(stringValue) ?? 0
        }
        
        public var decodeString: (CleanDecoder) throws -> String = { decoder in
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
        
        public init(decodeBool: @escaping (CleanDecoder) -> Bool,
                    decodeInt: @escaping (CleanDecoder) -> Int,
                    decodeUInt: @escaping (CleanDecoder) -> UInt,
                    decodeFloat: @escaping (CleanDecoder) -> Float,
                    decodeDouble: @escaping (CleanDecoder) -> Double,
                    decodeString: @escaping (CleanDecoder) -> String) {
            self.decodeBool = decodeBool
            self.decodeInt = decodeInt
            self.decodeUInt = decodeUInt
            self.decodeFloat = decodeFloat
            self.decodeDouble = decodeDouble
            self.decodeString = decodeString
        }
    }
}
