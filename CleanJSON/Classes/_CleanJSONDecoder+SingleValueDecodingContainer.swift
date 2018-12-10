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
        
        guard let value = try self.unbox(self.storage.topContainer, as: Bool.self) else {
            return try options.typeConvertionStrategy.convertToBool(self)
        }
        
        return value
    }
    
    public func decode(_ type: Int.Type) throws -> Int {
        try expectNonNull(Int.self)
        
        guard let value = try self.unbox(self.storage.topContainer, as: Int.self) else {
            return try options.typeConvertionStrategy.convertToInt(self)
        }
        
        return value
    }
    
    public func decode(_ type: Int8.Type) throws -> Int8 {
        try expectNonNull(Int8.self)
        return try self.unbox(self.storage.topContainer, as: Int8.self) ?? 0
    }
    
    public func decode(_ type: Int16.Type) throws -> Int16 {
        try expectNonNull(Int16.self)
        return try self.unbox(self.storage.topContainer, as: Int16.self) ?? 0
    }
    
    public func decode(_ type: Int32.Type) throws -> Int32 {
        try expectNonNull(Int32.self)
        return try self.unbox(self.storage.topContainer, as: Int32.self) ?? 0
    }
    
    public func decode(_ type: Int64.Type) throws -> Int64 {
        try expectNonNull(Int64.self)
        return try self.unbox(self.storage.topContainer, as: Int64.self) ?? 0
    }
    
    public func decode(_ type: UInt.Type) throws -> UInt {
        try expectNonNull(UInt.self)
        
        guard let value = try self.unbox(self.storage.topContainer, as: UInt.self) else {
            return try options.typeConvertionStrategy.convertToUInt(self)
        }
    
        return value
    }
    
    public func decode(_ type: UInt8.Type) throws -> UInt8 {
        try expectNonNull(UInt8.self)
        return try self.unbox(self.storage.topContainer, as: UInt8.self) ?? 0
    }
    
    public func decode(_ type: UInt16.Type) throws -> UInt16 {
        try expectNonNull(UInt16.self)
        return try self.unbox(self.storage.topContainer, as: UInt16.self) ?? 0
    }
    
    public func decode(_ type: UInt32.Type) throws -> UInt32 {
        try expectNonNull(UInt32.self)
        return try self.unbox(self.storage.topContainer, as: UInt32.self) ?? 0
    }
    
    public func decode(_ type: UInt64.Type) throws -> UInt64 {
        try expectNonNull(UInt64.self)
        return try self.unbox(self.storage.topContainer, as: UInt64.self) ?? 0
    }
    
    public func decode(_ type: Float.Type) throws -> Float {
        try expectNonNull(Float.self)
        
        guard let value = try self.unbox(self.storage.topContainer, as: Float.self) else {
            return try options.typeConvertionStrategy.convertToFloat(self)
        }
        
        return value
    }
    
    public func decode(_ type: Double.Type) throws -> Double {
        try expectNonNull(Double.self)
        
        guard let value = try self.unbox(self.storage.topContainer, as: Double.self) else {
            return try options.typeConvertionStrategy.convertToDouble(self)
        }
        
        return value
    }
    
    public func decode(_ type: String.Type) throws -> String {
        try expectNonNull(String.self)
        
        guard let value = try self.unbox(self.storage.topContainer, as: String.self) else {
            return try options.typeConvertionStrategy.convertToString(self)
        }
        
        return value
    }
    
    public func decode<T : Decodable>(_ type: T.Type) throws -> T {
        try expectNonNull(type)
        return try self.unbox(self.storage.topContainer, as: type)!
    }
}
