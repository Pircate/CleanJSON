// 
//  CleanDecoder.swift
//  CleanJSON
//
//  Created by Pircate(gao497868860@gmail.com) on 2018/12/10
//  Copyright © 2018 Pircate. All rights reserved.
//

import Foundation

public protocol CleanDecoder {
    
    func decodeNull() -> Bool
    
    func decode(_ type: Bool.Type) throws -> Bool?
    
    func decode(_ type: Int.Type) throws -> Int?
    
    func decode(_ type: Int8.Type) throws -> Int8?
    
    func decode(_ type: Int16.Type) throws -> Int16?
    
    func decode(_ type: Int32.Type) throws -> Int32?
    
    func decode(_ type: Int64.Type) throws -> Int64?
    
    func decode(_ type: UInt.Type) throws -> UInt?
    
    func decode(_ type: UInt8.Type) throws -> UInt8?
    
    func decode(_ type: UInt16.Type) throws -> UInt16?
    
    func decode(_ type: UInt32.Type) throws -> UInt32?
    
    func decode(_ type: UInt64.Type) throws -> UInt64?
    
    func decode(_ type: Float.Type) throws -> Float?
    
    func decode(_ type: Double.Type) throws -> Double?
    
    func decode(_ type: String.Type) throws -> String?
    
    func decode(_ type: Date.Type) throws -> Date?
    
    func decode(_ type: Data.Type) throws -> Data?
    
    func decode(_ type: Decimal.Type) throws -> Decimal?
}

extension _CleanJSONDecoder: CleanDecoder {
    
    func decodeNull() -> Bool {
        return storage.topContainer is NSNull
    }
    
    func decode(_ type: Bool.Type) throws -> Bool? {
        return try unbox(storage.topContainer, as: type)
    }
    
    func decode(_ type: Int.Type) throws -> Int? {
        return try unbox(storage.topContainer, as: type)
    }
    
    func decode(_ type: Int8.Type) throws -> Int8? {
        return try unbox(storage.topContainer, as: type)
    }
    
    func decode(_ type: Int16.Type) throws -> Int16? {
        return try unbox(storage.topContainer, as: type)
    }
    
    func decode(_ type: Int32.Type) throws -> Int32? {
        return try unbox(storage.topContainer, as: type)
    }
    
    func decode(_ type: Int64.Type) throws -> Int64? {
        return try unbox(storage.topContainer, as: type)
    }
    
    func decode(_ type: UInt.Type) throws -> UInt? {
        return try unbox(storage.topContainer, as: type)
    }
    
    func decode(_ type: UInt8.Type) throws -> UInt8? {
        return try unbox(storage.topContainer, as: type)
    }
    
    func decode(_ type: UInt16.Type) throws -> UInt16? {
        return try unbox(storage.topContainer, as: type)
    }
    
    func decode(_ type: UInt32.Type) throws -> UInt32? {
        return try unbox(storage.topContainer, as: type)
    }
    
    func decode(_ type: UInt64.Type) throws -> UInt64? {
        return try unbox(storage.topContainer, as: type)
    }
    
    func decode(_ type: Float.Type) throws -> Float? {
        return try unbox(storage.topContainer, as: type)
    }
    
    func decode(_ type: Double.Type) throws -> Double? {
        return try unbox(storage.topContainer, as: type)
    }
    
    func decode(_ type: String.Type) throws -> String? {
        return try unbox(storage.topContainer, as: type)
    }
    
    func decode(_ type: Date.Type) throws -> Date? {
        return try unbox(storage.topContainer, as: type)
    }
    
    func decode(_ type: Data.Type) throws -> Data? {
        return try unbox(storage.topContainer, as: type)
    }
    
    func decode(_ type: Decimal.Type) throws -> Decimal? {
        return try unbox(storage.topContainer, as: type)
    }
}
