// 
//  _CleanJSONDecoder+SingleValueDecodingContainer.swift
//  CleanJSON
//
//  Created by Pircate(gao497868860@gmail.com) on 2018/10/11
//  Copyright © 2018 Pircate. All rights reserved.
//

import Foundation

extension _CleanJSONDecoder : SingleValueDecodingContainer {
    // MARK: SingleValueDecodingContainer Methods
    
    private func expectNonNull<T>(_ type: T.Type) throws {
        
    }
    
    public func decodeNil() -> Bool {
        return self.storage.topContainer is NSNull
    }
    
    public func decode(_ type: Bool.Type) throws -> Bool {
        try expectNonNull(Bool.self)
        
        guard let value = try self.unbox(storage.topContainer, as: Bool.self) else {
            switch options.valueNotFoundDecodingStrategy {
            case .throw:
                throw DecodingError.Keyed.valueNotFound(type, codingPath: codingPath)
            case .useDefaultValue:
                return Bool.defaultValue
            case .custom(let adaptor):
                return try adaptor.decodeBool(self)
            }
        }
        
        return value
    }
    
    public func decode(_ type: Int.Type) throws -> Int {
        try expectNonNull(Int.self)
        
        guard let value = try self.unbox(self.storage.topContainer, as: Int.self) else {
            switch options.valueNotFoundDecodingStrategy {
            case .throw:
                throw DecodingError.Keyed.valueNotFound(type, codingPath: codingPath)
            case .useDefaultValue:
                return Int.defaultValue
            case .custom(let adaptor):
                return try adaptor.decodeInt(self)
            }
        }
        
        return value
    }
    
    public func decode(_ type: Int8.Type) throws -> Int8 {
        try expectNonNull(Int8.self)
        return try self.unbox(self.storage.topContainer, as: Int8.self) ?? Int8.defaultValue
    }
    
    public func decode(_ type: Int16.Type) throws -> Int16 {
        try expectNonNull(Int16.self)
        return try self.unbox(self.storage.topContainer, as: Int16.self) ?? Int16.defaultValue
    }
    
    public func decode(_ type: Int32.Type) throws -> Int32 {
        try expectNonNull(Int32.self)
        return try self.unbox(self.storage.topContainer, as: Int32.self) ?? Int32.defaultValue
    }
    
    public func decode(_ type: Int64.Type) throws -> Int64 {
        try expectNonNull(Int64.self)
        return try self.unbox(self.storage.topContainer, as: Int64.self) ?? Int64.defaultValue
    }
    
    public func decode(_ type: UInt.Type) throws -> UInt {
        try expectNonNull(UInt.self)
        
        guard let value = try self.unbox(self.storage.topContainer, as: UInt.self) else {
            switch options.valueNotFoundDecodingStrategy {
            case .throw:
                throw DecodingError.Keyed.valueNotFound(type, codingPath: codingPath)
            case .useDefaultValue:
                return UInt.defaultValue
            case .custom(let adaptor):
                return try adaptor.decodeUInt(self)
            }
        }
    
        return value
    }
    
    public func decode(_ type: UInt8.Type) throws -> UInt8 {
        try expectNonNull(UInt8.self)
        return try self.unbox(self.storage.topContainer, as: UInt8.self) ?? UInt8.defaultValue
    }
    
    public func decode(_ type: UInt16.Type) throws -> UInt16 {
        try expectNonNull(UInt16.self)
        return try self.unbox(self.storage.topContainer, as: UInt16.self) ?? UInt16.defaultValue
    }
    
    public func decode(_ type: UInt32.Type) throws -> UInt32 {
        try expectNonNull(UInt32.self)
        return try self.unbox(self.storage.topContainer, as: UInt32.self) ?? UInt32.defaultValue
    }
    
    public func decode(_ type: UInt64.Type) throws -> UInt64 {
        try expectNonNull(UInt64.self)
        return try self.unbox(self.storage.topContainer, as: UInt64.self) ?? UInt64.defaultValue
    }
    
    public func decode(_ type: Float.Type) throws -> Float {
        try expectNonNull(Float.self)
        
        guard let value = try self.unbox(self.storage.topContainer, as: Float.self) else {
            switch options.valueNotFoundDecodingStrategy {
            case .throw:
                throw DecodingError.Keyed.valueNotFound(type, codingPath: codingPath)
            case .useDefaultValue:
                return Float.defaultValue
            case .custom(let adaptor):
                return try adaptor.decodeFloat(self)
            }
        }
        
        return value
    }
    
    public func decode(_ type: Double.Type) throws -> Double {
        try expectNonNull(Double.self)
        
        guard let value = try self.unbox(self.storage.topContainer, as: Double.self) else {
            switch options.valueNotFoundDecodingStrategy {
            case .throw:
                throw DecodingError.Keyed.valueNotFound(type, codingPath: codingPath)
            case .useDefaultValue:
                return Double.defaultValue
            case .custom(let adaptor):
                return try adaptor.decodeDouble(self)
            }
        }
        
        return value
    }
    
    public func decode(_ type: String.Type) throws -> String {
        try expectNonNull(String.self)
        
        guard let value = try self.unbox(self.storage.topContainer, as: String.self) else {
            switch options.valueNotFoundDecodingStrategy {
            case .throw:
                throw DecodingError.Keyed.valueNotFound(type, codingPath: codingPath)
            case .useDefaultValue:
                return String.defaultValue
            case .custom(let adaptor):
                return try adaptor.decodeString(self)
            }
        }
        
        return value
    }
    
    public func decode<T : Decodable>(_ type: T.Type) throws -> T {
        try expectNonNull(type)
        return try self.unbox(self.storage.topContainer, as: type)!
    }
}
