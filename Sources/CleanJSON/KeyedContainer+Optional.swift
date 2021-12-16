//
//  KeyedContainer+Optional.swift
//  CleanJSON
//
//  Created by Pircate(swifter.dev@gmail.com) on 2021/12/16
//  Copyright © 2021 Pircate. All rights reserved.
//

import Foundation

extension JSONDecoderImpl.KeyedContainer {
    
    func decodeIfPresent(_ type: Bool.Type, forKey key: K) throws -> Bool? {
        guard contains(key), let value = try? getValue(forKey: key) else {
            return nil
        }
        
        do {
            return try impl.unwrapBool(from: value, for: key)
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
    
    func decodeIfPresent(_ type: String.Type, forKey key: K) throws -> String? {
        guard contains(key), let value = try? getValue(forKey: key) else {
            return nil
        }
        
        do {
            return try impl.unwrapString(from: value, for: key)
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
    
    func decodeIfPresent(_ type: Double.Type, forKey key: K) throws -> Double? {
        try decodeFloatingPointIfPresent(type, forKey: key)
    }
    
    func decodeIfPresent(_ type: Float.Type, forKey key: K) throws -> Float? {
        try decodeFloatingPointIfPresent(type, forKey: key)
    }
    
    func decodeIfPresent(_ type: Int.Type, forKey key: K) throws -> Int? {
        try decodeFixedWidthIntegerIfPresent(type, forKey: key)
    }
    
    func decodeIfPresent(_ type: Int8.Type, forKey key: K) throws -> Int8? {
        try decodeFixedWidthIntegerIfPresent(type, forKey: key)
    }
    
    func decodeIfPresent(_ type: Int16.Type, forKey key: K) throws -> Int16? {
        try decodeFixedWidthIntegerIfPresent(type, forKey: key)
    }
    
    func decodeIfPresent(_ type: Int32.Type, forKey key: K) throws -> Int32? {
        try decodeFixedWidthIntegerIfPresent(type, forKey: key)
    }
    
    func decodeIfPresent(_ type: Int64.Type, forKey key: K) throws -> Int64? {
        try decodeFixedWidthIntegerIfPresent(type, forKey: key)
    }
    
    func decodeIfPresent(_ type: UInt.Type, forKey key: K) throws -> UInt? {
        try decodeFixedWidthIntegerIfPresent(type, forKey: key)
    }
    
    func decodeIfPresent(_ type: UInt8.Type, forKey key: K) throws -> UInt8? {
        try decodeFixedWidthIntegerIfPresent(type, forKey: key)
    }
    
    func decodeIfPresent(_ type: UInt16.Type, forKey key: K) throws -> UInt16? {
        try decodeFixedWidthIntegerIfPresent(type, forKey: key)
    }
    
    func decodeIfPresent(_ type: UInt32.Type, forKey key: K) throws -> UInt32? {
        try decodeFixedWidthIntegerIfPresent(type, forKey: key)
    }
    
    func decodeIfPresent(_ type: UInt64.Type, forKey key: K) throws -> UInt64? {
        try decodeFixedWidthIntegerIfPresent(type, forKey: key)
    }
    
    func decodeIfPresent<T>(_ type: T.Type, forKey key: K) throws -> T? where T : Decodable {
        guard contains(key), let newDecoder = try? decoderForKey(key) else {
            return nil
        }
        
        if type == Date.self || type == NSDate.self {
            return try newDecoder.decodeIfPresent(Date.self) as? T
        } else if type == Data.self || type == NSData.self {
            return try newDecoder.decodeIfPresent(Data.self) as? T
        } else if type == URL.self || type == NSURL.self {
            return try newDecoder.decodeIfPresent(URL.self) as? T
        } else if type == Decimal.self || type == NSDecimalNumber.self {
            return try newDecoder.decodeIfPresent(Decimal.self) as? T
        }
        
        // 以上类型支持 adapter 所以不直接判断是否为 null
        if try decodeNil(forKey: key) {
            return nil
        }
        
        func decode(from decoder: JSONDecoderImpl) throws -> T? {
            do {
                return try decoder.unwrap(as: T.self)
            } catch {
                switch impl.options.valueNotFoundDecodingStrategy {
                case .throw:
                    throw error
                case .useDefaultValue, .custom:
                    return nil
                }
            }
        }
        
        // 若期望解析的类型是字符串类型，则正常解析
        if let _ = String.defaultValue as? T {
            return try decode(from: newDecoder)
        }
        
        // 若原始值不是有效的 JSON 字符串则正常解析
        guard let jsonStringDecoder = try? jsonStringDecoder(from: newDecoder) else {
            return try decode(from: newDecoder)
        }
        
        switch impl.options.jsonStringDecodingStrategy {
        case .containsKeys(let keys) where keys.contains(where: { $0.stringValue == key.stringValue }):
            return try decode(from: jsonStringDecoder)
        case .all:
            return try decode(from: jsonStringDecoder)
        default:
            return try decode(from: newDecoder)
        }
    }
    
    func jsonStringDecoder(from decoder: JSONDecoderImpl) throws -> JSONDecoderImpl? {
        guard case .string(let value) = decoder.json, let data = value.toJSONData() else {
            return nil
        }
        
        var parser = JSONParser(bytes: Array(data))
        let json = try parser.parse()
        
        return JSONDecoderImpl(
            userInfo: decoder.userInfo,
            from: json,
            codingPath: decoder.codingPath,
            options: decoder.options
        )
    }
}

private extension JSONDecoderImpl.KeyedContainer {
    
    func decodeFloatingPointIfPresent<T: LosslessStringConvertible & BinaryFloatingPoint>(
        _ type: T.Type,
        forKey key: K
    ) throws -> T? {
        guard contains(key), let value = try? getValue(forKey: key) else {
            return nil
        }
        
        do {
            return try impl.unwrapFloatingPoint(from: value, for: key, as: T.self)
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
    
    func decodeFixedWidthIntegerIfPresent<T: FixedWidthInteger>(_ type: T.Type, forKey key: K) throws -> T? {
        guard contains(key), let value = try? getValue(forKey: key) else {
            return nil
        }
        
        do {
            return try impl.unwrapFixedWidthInteger(from: value, for: key, as: T.self)
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

extension JSONDecoderImpl {
    
    func decodeIfPresent(_ type: Date.Type) throws -> Date? {
        do {
            return try unwrapDate()
        } catch {
            switch options.valueNotFoundDecodingStrategy {
            case .throw:
                throw error
            case .useDefaultValue:
                return nil
            case .custom(let adapter):
                return try adapter.adaptIfPresent(json, from: self)
            }
        }
    }
    
    func decodeIfPresent(_ type: Data.Type) throws -> Data? {
        do {
            return try unwrapData()
        } catch {
            switch options.valueNotFoundDecodingStrategy {
            case .throw:
                throw error
            case .useDefaultValue:
                return nil
            case .custom(let adapter):
                return try adapter.adaptIfPresent(json, from: self)
            }
        }
    }
    
    func decodeIfPresent(_ type: URL.Type) throws -> URL? {
        do {
            return try unwrapURL()
        } catch {
            switch options.valueNotFoundDecodingStrategy {
            case .throw:
                throw error
            case .useDefaultValue:
                return nil
            case .custom(let adapter):
                return try adapter.adaptIfPresent(json, from: self)
            }
        }
    }
    
    func decodeIfPresent(_ type: Decimal.Type) throws -> Decimal? {
        do {
            return try unwrapDecimal()
        } catch {
            switch options.valueNotFoundDecodingStrategy {
            case .throw:
                throw error
            case .useDefaultValue:
                return nil
            case .custom(let adapter):
                return try adapter.adaptIfPresent(json, from: self)
            }
        }
    }
    
    func decodeAsDefaultValue<T: Decodable>() throws -> T {
        if let array = [] as? T {
            return array
        } else if let string = String.defaultValue as? T {
            return string
        } else if let bool = Bool.defaultValue as? T {
            return bool
        } else if let int = Int.defaultValue as? T {
            return int
        }else if let double = Double.defaultValue as? T {
            return double
        } else if let date = Date.defaultValue(for: options.dateDecodingStrategy) as? T {
            return date
        } else if let data = Data.defaultValue as? T {
            return data
        } else if let decimal = Decimal.defaultValue as? T {
            return decimal
        }
        
        let context = DecodingError.Context(
            codingPath: codingPath,
            debugDescription: "Key: <\(codingPath)> cannot be decoded as default value."
        )
        throw DecodingError.dataCorrupted(context)
    }
}

private extension String {
    
    func toJSONData() -> Data? {
        // 过滤掉非 JSON 格式字符串
        guard hasPrefix("{") || hasPrefix("[") else { return nil }
        
        return data(using: .utf8)
    }
}
