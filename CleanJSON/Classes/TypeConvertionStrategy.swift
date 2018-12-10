// 
//  TypeConvertionStrategy.swift
//  CleanJSON
//
//  Created by Pircate(gao497868860@gmail.com) on 2018/12/10
//  Copyright © 2018 Pircate. All rights reserved.
//

import Foundation

extension CleanJSONDecoder {
    
    public class TypeConvertionStrategy {
        
        public var convertToBool: (CleanDecoder) throws -> Bool = { _ in false }
        
        public var convertToInt: (CleanDecoder) throws -> Int = { decoder in
            guard let stringValue = try decoder.decode(String.self) else {
                return 0
            }
            return Int(stringValue) ?? 0
        }
        
        public var convertToUInt: (CleanDecoder) throws -> UInt = { decoder in
            guard let stringValue = try decoder.decode(String.self) else {
                return 0
            }
            return UInt(stringValue) ?? 0
        }
        
        public var convertToFloat: (CleanDecoder) throws -> Float = { decoder in
            guard let stringValue = try decoder.decode(String.self) else {
                return 0
            }
            return Float(stringValue) ?? 0
        }
        
        public var convertToDouble: (CleanDecoder) throws -> Double = { decoder in
            guard let stringValue = try decoder.decode(String.self) else {
                return 0
            }
            return Double(stringValue) ?? 0
        }
        
        public var convertToString: (CleanDecoder) throws -> String = { decoder in
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
