//
//  UnkeyedContainer+Optional.swift
//  CleanJSON
//
//  Created by Pircate(swifter.dev@gmail.com) on 2021/12/16
//  Copyright © 2021 Pircate. All rights reserved.
//

import Foundation

extension JSONDecoderImpl.UnkeyedContainer {
    
    mutating func decodeIfPresent(_ type: Bool.Type) throws -> Bool? {
        let value = try getNextValue(ofType: type)
        
        do {
            return try impl.unwrapBool(from: value, for: JSONKey(index: currentIndex))
        } catch {
            switch impl.options.valueNotFoundDecodingStrategy {
            case .throw:
                throw error
            case .useDefaultValue:
                return nil
            case .custom(let adapter):
                return try adapter.adaptIfPresent(value, from: impl)
            }
        }
    }
    
    func decodeIfPresent(_ type: String.Type) throws -> String? {
        let value = try getNextValue(ofType: type)
        
        do {
            return try impl.unwrapString(from: value, for: JSONKey(index: currentIndex))
        } catch {
            switch impl.options.valueNotFoundDecodingStrategy {
            case .throw:
                throw error
            case .useDefaultValue:
                return nil
            case .custom(let adapter):
                return try adapter.adaptIfPresent(value, from: impl)
            }
        }
    }
    
    func decodeIfPresent(_ type: Double.Type) throws -> Double? {
        try decodeFloatingPointIfPresent(type)
    }
    
    func decodeIfPresent(_ type: Float.Type) throws -> Float? {
        try decodeFloatingPointIfPresent(type)
    }
    
    func decodeIfPresent(_ type: Int.Type) throws -> Int? {
        try decodeFixedWidthIntegerIfPresent(type)
    }
    
    func decodeIfPresent(_ type: Int8.Type) throws -> Int8? {
        try decodeFixedWidthIntegerIfPresent(type)
    }
    
    func decodeIfPresent(_ type: Int16.Type) throws -> Int16? {
        try decodeFixedWidthIntegerIfPresent(type)
    }
    
    func decodeIfPresent(_ type: Int32.Type) throws -> Int32? {
        try decodeFixedWidthIntegerIfPresent(type)
    }
    
    func decodeIfPresent(_ type: Int64.Type) throws -> Int64? {
        try decodeFixedWidthIntegerIfPresent(type)
    }
    
    func decodeIfPresent(_ type: UInt.Type) throws -> UInt? {
        try decodeFixedWidthIntegerIfPresent(type)
    }
    
    func decodeIfPresent(_ type: UInt8.Type) throws -> UInt8? {
        try decodeFixedWidthIntegerIfPresent(type)
    }
    
    func decodeIfPresent(_ type: UInt16.Type) throws -> UInt16? {
        try decodeFixedWidthIntegerIfPresent(type)
    }
    
    func decodeIfPresent(_ type: UInt32.Type) throws -> UInt32? {
        try decodeFixedWidthIntegerIfPresent(type)
    }
    
    func decodeIfPresent(_ type: UInt64.Type) throws -> UInt64? {
        try decodeFixedWidthIntegerIfPresent(type)
    }
    
    mutating func decodeIfPresent<T>(_ type: T.Type) throws -> T? where T : Decodable {
        let newDecoder = try decoderForNextElement(ofType: type)
        
        if type == Date.self || type == NSDate.self {
            return try newDecoder.decodeIfPresent(Date.self) as? T
        } else if type == Data.self || type == NSData.self {
            return try newDecoder.decodeIfPresent(Data.self) as? T
        } else if type == URL.self || type == NSURL.self {
            return try newDecoder.decodeIfPresent(URL.self) as? T
        } else if type == Decimal.self || type == NSDecimalNumber.self {
            return try newDecoder.decodeIfPresent(Decimal.self) as? T
        }
        
        do {
            return try newDecoder.unwrap(as: T.self)
        } catch {
            switch impl.options.valueNotFoundDecodingStrategy {
            case .throw:
                throw error
            case .useDefaultValue, .custom:
                return nil
            }
        }
    }
}

private extension JSONDecoderImpl.UnkeyedContainer {
    
    func decodeFloatingPointIfPresent<T: LosslessStringConvertible & BinaryFloatingPoint>(
        _ type: T.Type
    ) throws -> T? {
        let value = try getNextValue(ofType: type)
        
        do {
            return try impl.unwrapFloatingPoint(
                from: value,
                for: JSONKey(index: currentIndex),
                as: T.self
            )
        } catch {
            switch impl.options.valueNotFoundDecodingStrategy {
            case .throw:
                throw error
            case .useDefaultValue:
                return nil
            case .custom(let adapter):
                return try adapter.adaptIfPresent(value, from: impl)
            }
        }
    }
    
    func decodeFixedWidthIntegerIfPresent<T: FixedWidthInteger>(_ type: T.Type) throws -> T? {
        let value = try getNextValue(ofType: type)
        
        do {
            return try impl.unwrapFixedWidthInteger(
                from: value,
                for: JSONKey(index: currentIndex),
                as: T.self
            )
        } catch {
            switch impl.options.valueNotFoundDecodingStrategy {
            case .throw:
                throw error
            case .useDefaultValue:
                return nil
            case .custom(let adapter):
                return try adapter.adaptIfPresent(value, from: impl)
            }
        }
    }
}
