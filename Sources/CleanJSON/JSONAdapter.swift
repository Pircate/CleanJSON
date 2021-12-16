// 
//  JSONAdapter.swift
//  CleanJSON
//
//  Created by Pircate(swifter.dev@gmail.com) on 2018/12/13
//  Copyright © 2018 Pircate. All rights reserved.
//

import Foundation

public protocol JSONAdapter {
    
    func adapt(_ value: JSONValue, from decoder: Decoder) throws -> Bool
    
    func adapt(_ value: JSONValue, from decoder: Decoder) throws -> String
    
    func adapt<T: FixedWidthInteger>(_ value: JSONValue, from decoder: Decoder) throws -> T
    
    func adapt<T: LosslessStringConvertible & BinaryFloatingPoint>(
        _ value: JSONValue,
        from decoder: Decoder
    ) throws -> T
    
    func adapt(_ value: JSONValue, from decoder: Decoder) throws -> Date
    
    func adapt(_ value: JSONValue, from decoder: Decoder) throws -> Data
    
    func adapt(_ value: JSONValue, from decoder: Decoder) throws -> Decimal
    
    func adaptIfPresent(_ value: JSONValue, from decoder: Decoder) throws -> Bool?
    
    func adaptIfPresent(_ value: JSONValue, from decoder: Decoder) throws -> String?
    
    func adaptIfPresent<T: FixedWidthInteger>(_ value: JSONValue, from decoder: Decoder) throws -> T?
    
    func adaptIfPresent<T: LosslessStringConvertible & BinaryFloatingPoint>(
        _ value: JSONValue,
        from decoder: Decoder
    ) throws -> T?
    
    func adaptIfPresent(_ value: JSONValue, from decoder: Decoder) throws -> Date?
    
    func adaptIfPresent(_ value: JSONValue, from decoder: Decoder) throws -> Data?
    
    func adaptIfPresent(_ value: JSONValue, from decoder: Decoder) throws -> URL?
    
    func adaptIfPresent(_ value: JSONValue, from decoder: Decoder) throws -> Decimal?
}

public extension JSONAdapter {
    
    func adapt(_ value: JSONValue, from decoder: Decoder) throws -> Bool {
        .defaultValue
    }
    
    func adapt(_ value: JSONValue, from decoder: Decoder) throws -> String {
        switch value {
        case .number(let stringValue):
            return stringValue
        case .bool(let boolValue):
            return String(describing: boolValue)
        default:
            return .defaultValue
        }
    }
    
    func adapt<T: FixedWidthInteger>(_ value: JSONValue, from decoder: Decoder) throws -> T {
        switch value {
        case .string(let stringValue):
            return T.init(stringValue) ?? 0
        default:
            return 0
        }
    }
    
    func adapt<T: LosslessStringConvertible & BinaryFloatingPoint>(
        _ value: JSONValue,
        from decoder: Decoder
    ) throws -> T {
        switch value {
        case .string(let stringValue):
            return T.init(stringValue) ?? 0
        default:
            return 0
        }
    }
    
    func adapt(_ value: JSONValue, from decoder: Decoder) throws -> Date {
        guard let decoder = decoder as? JSONDecoderImpl else { return .defaultValue }
        
        return .defaultValue(for: decoder.options.dateDecodingStrategy)
    }
    
    func adapt(_ value: JSONValue, from decoder: Decoder) throws -> Data {
        .defaultValue
    }
    
    func adapt(_ value: JSONValue, from decoder: Decoder) throws -> Decimal {
        .defaultValue
    }
    
    func adaptIfPresent(_ value: JSONValue, from decoder: Decoder) throws -> Bool? {
        nil
    }
    
    func adaptIfPresent(_ value: JSONValue, from decoder: Decoder) throws -> String? {
        nil
    }
    
    func adaptIfPresent<T: FixedWidthInteger>(_ value: JSONValue, from decoder: Decoder) throws -> T? {
        nil
    }
    
    func adaptIfPresent<T: LosslessStringConvertible & BinaryFloatingPoint>(
        _ value: JSONValue,
        from decoder: Decoder
    ) throws -> T? {
        nil
    }
    
    func adaptIfPresent(_ value: JSONValue, from decoder: Decoder) throws -> Date? {
        nil
    }
    
    func adaptIfPresent(_ value: JSONValue, from decoder: Decoder) throws -> Data? {
        nil
    }
    
    func adaptIfPresent(_ value: JSONValue, from decoder: Decoder) throws -> URL? {
        nil
    }
    
    func adaptIfPresent(_ value: JSONValue, from decoder: Decoder) throws -> Decimal? {
        nil
    }
}

extension CleanJSONDecoder {
    
    struct Adapter: JSONAdapter {}
}
