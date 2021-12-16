//
//  JSONDecoderImpl+KeyedContainer.swift
//  CleanJSON
//
//  Created by Pircate(swifter.dev@gmail.com) on 2021/12/16
//  Copyright © 2021 Pircate. All rights reserved.
//

import Foundation

extension JSONDecoderImpl {
    
    struct KeyedContainer<K: CodingKey>: KeyedDecodingContainerProtocol {
        typealias Key = K

        let impl: JSONDecoderImpl
        let codingPath: [CodingKey]
        let dictionary: [String: JSONValue]

        init(impl: JSONDecoderImpl, codingPath: [CodingKey], dictionary: [String: JSONValue]) {
            self.impl = impl
            self.codingPath = codingPath

            switch impl.options.keyDecodingStrategy {
            case .useDefaultKeys:
                self.dictionary = dictionary
            case .convertFromSnakeCase:
                // Convert the snake case keys in the container to camel case.
                // If we hit a duplicate key after conversion, then we'll use the first one we saw.
                // Effectively an undefined behavior with JSON dictionaries.
                var converted = [String: JSONValue]()
                converted.reserveCapacity(dictionary.count)
                dictionary.forEach { (key, value) in
                    converted[JSONDecoder.KeyDecodingStrategy._convertFromSnakeCase(key)] = value
                }
                self.dictionary = converted
            case .custom(let converter):
                var converted = [String: JSONValue]()
                converted.reserveCapacity(dictionary.count)
                dictionary.forEach { (key, value) in
                    var pathForKey = codingPath
                    pathForKey.append(JSONKey(stringValue: key)!)
                    converted[converter(pathForKey).stringValue] = value
                }
                self.dictionary = converted
            }
        }

        var allKeys: [K] {
            self.dictionary.keys.compactMap { K(stringValue: $0) }
        }

        func contains(_ key: K) -> Bool {
            if let _ = dictionary[key.stringValue] {
                return true
            }
            return false
        }

        func decodeNil(forKey key: K) throws -> Bool {
            let value = try getValue(forKey: key)
            return value == .null
        }

        func decode(_ type: Bool.Type, forKey key: K) throws -> Bool {
            let value: JSONValue
            
            do {
                value = try getValue(forKey: key)
            } catch {
                switch impl.options.keyNotFoundDecodingStrategy {
                case .throw:
                    throw error
                case .useDefaultValue:
                    return .defaultValue
                }
            }

            guard case .bool(let bool) = value else {
                switch impl.options.valueNotFoundDecodingStrategy {
                case .throw:
                    throw createTypeMismatchError(type: type, forKey: key, value: value)
                case .useDefaultValue:
                    return .defaultValue
                case .custom(let adapter):
                    return try adapter.adapt(value, from: impl)
                }
            }

            return bool
        }

        func decode(_ type: String.Type, forKey key: K) throws -> String {
            let value: JSONValue
            
            do {
                value = try getValue(forKey: key)
            } catch {
                switch impl.options.keyNotFoundDecodingStrategy {
                case .throw:
                    throw error
                case .useDefaultValue:
                    return .defaultValue
                }
            }

            guard case .string(let string) = value else {
                switch impl.options.valueNotFoundDecodingStrategy {
                case .throw:
                    throw createTypeMismatchError(type: type, forKey: key, value: value)
                case .useDefaultValue:
                    return .defaultValue
                case .custom(let adapter):
                    return try adapter.adapt(value, from: impl)
                }
            }

            return string
        }

        func decode(_: Double.Type, forKey key: K) throws -> Double {
            try decodeFloatingPoint(key: key)
        }

        func decode(_: Float.Type, forKey key: K) throws -> Float {
            try decodeFloatingPoint(key: key)
        }

        func decode(_: Int.Type, forKey key: K) throws -> Int {
            try decodeFixedWidthInteger(key: key)
        }

        func decode(_: Int8.Type, forKey key: K) throws -> Int8 {
            try decodeFixedWidthInteger(key: key)
        }

        func decode(_: Int16.Type, forKey key: K) throws -> Int16 {
            try decodeFixedWidthInteger(key: key)
        }

        func decode(_: Int32.Type, forKey key: K) throws -> Int32 {
            try decodeFixedWidthInteger(key: key)
        }

        func decode(_: Int64.Type, forKey key: K) throws -> Int64 {
            try decodeFixedWidthInteger(key: key)
        }

        func decode(_: UInt.Type, forKey key: K) throws -> UInt {
            try decodeFixedWidthInteger(key: key)
        }

        func decode(_: UInt8.Type, forKey key: K) throws -> UInt8 {
            try decodeFixedWidthInteger(key: key)
        }

        func decode(_: UInt16.Type, forKey key: K) throws -> UInt16 {
            try decodeFixedWidthInteger(key: key)
        }

        func decode(_: UInt32.Type, forKey key: K) throws -> UInt32 {
            try decodeFixedWidthInteger(key: key)
        }

        func decode(_: UInt64.Type, forKey key: K) throws -> UInt64 {
            try decodeFixedWidthInteger(key: key)
        }

        func decode<T>(_: T.Type, forKey key: K) throws -> T where T: Decodable {
            let newDecoder: JSONDecoderImpl
            
            do {
                newDecoder = try decoderForKey(key)
            } catch {
                switch impl.options.nestedContainerDecodingStrategy.keyNotFound {
                case .throw:
                    throw error
                case .useEmptyContainer:
                    var newPath = self.codingPath
                    newPath.append(key)
                    newDecoder = JSONDecoderImpl(
                        userInfo: self.impl.userInfo,
                        from: .object([:]),
                        codingPath: newPath,
                        options: self.impl.options
                    )
                }
            }
            
            func decode(from decoder: JSONDecoderImpl) throws -> T {
                do {
                    return try decoder.unwrap(as: T.self)
                } catch {
                    switch impl.options.valueNotFoundDecodingStrategy {
                    case .throw:
                        throw error
                    case .useDefaultValue, .custom:
                        return try decoder.decodeAsDefaultValue()
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

        func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: K) throws
            -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey
        {
            let newDecoder: JSONDecoderImpl
            do {
                newDecoder = try decoderForKey(key)
            } catch {
                switch impl.options.nestedContainerDecodingStrategy.keyNotFound {
                case .throw:
                    throw error
                case .useEmptyContainer:
                    var newPath = self.codingPath
                    newPath.append(key)
                    newDecoder = JSONDecoderImpl(
                        userInfo: self.impl.userInfo,
                        from: .object([:]),
                        codingPath: newPath,
                        options: self.impl.options
                    )
                }
            }
            
            return try newDecoder.container(keyedBy: type)
        }

        func nestedUnkeyedContainer(forKey key: K) throws -> UnkeyedDecodingContainer {
            let newDecoder: JSONDecoderImpl
            do {
                newDecoder = try decoderForKey(key)
            } catch {
                switch impl.options.nestedContainerDecodingStrategy.keyNotFound {
                case .throw:
                    throw error
                case .useEmptyContainer:
                    var newPath = self.codingPath
                    newPath.append(key)
                    newDecoder = JSONDecoderImpl(
                        userInfo: self.impl.userInfo,
                        from: .array([]),
                        codingPath: newPath,
                        options: self.impl.options
                    )
                }
            }
            
            return try newDecoder.unkeyedContainer()
        }

        func superDecoder() throws -> Decoder {
            try decoderForKey(JSONKey.super)
        }

        func superDecoder(forKey key: K) throws -> Decoder {
            try decoderForKey(key)
        }

        func decoderForKey<LocalKey: CodingKey>(_ key: LocalKey) throws -> JSONDecoderImpl {
            let value = try getValue(forKey: key)
            var newPath = self.codingPath
            newPath.append(key)

            return JSONDecoderImpl(
                userInfo: self.impl.userInfo,
                from: value,
                codingPath: newPath,
                options: self.impl.options
            )
        }

        @inline(__always) func getValue<LocalKey: CodingKey>(forKey key: LocalKey) throws -> JSONValue {
            guard let value = dictionary[key.stringValue] else {
                throw DecodingError.keyNotFound(key, .init(
                    codingPath: self.codingPath,
                    debugDescription: "No value associated with key \(key) (\"\(key.stringValue)\")."
                ))
            }

            return value
        }

        @inline(__always) private func createTypeMismatchError(type: Any.Type, forKey key: K, value: JSONValue) -> DecodingError {
            let codingPath = self.codingPath + [key]
            return DecodingError.typeMismatch(type, .init(
                codingPath: codingPath, debugDescription: "Expected to decode \(type) but found \(value.debugDataTypeDescription) instead."
            ))
        }

        @inline(__always) private func decodeFixedWidthInteger<T: FixedWidthInteger>(key: Self.Key) throws -> T {
            let value: JSONValue
            
            do {
                value = try getValue(forKey: key)
            } catch {
                switch impl.options.keyNotFoundDecodingStrategy {
                case .throw:
                    throw error
                case .useDefaultValue:
                    return 0
                }
            }
            
            do {
                return try self.impl.unwrapFixedWidthInteger(from: value, for: key, as: T.self)
            } catch {
                switch impl.options.valueNotFoundDecodingStrategy {
                case .throw:
                    throw error
                case .useDefaultValue:
                    return 0
                case .custom(let adapter):
                    return try adapter.adapt(value, from: impl)
                }
            }
        }

        @inline(__always) private func decodeFloatingPoint<T: LosslessStringConvertible & BinaryFloatingPoint>(key: K) throws -> T {
            let value: JSONValue
            
            do {
                value = try getValue(forKey: key)
            } catch {
                switch impl.options.keyNotFoundDecodingStrategy {
                case .throw:
                    throw error
                case .useDefaultValue:
                    return 0
                }
            }
            
            do {
                return try self.impl.unwrapFloatingPoint(from: value, for: key, as: T.self)
            } catch {
                switch impl.options.valueNotFoundDecodingStrategy {
                case .throw:
                    throw error
                case .useDefaultValue:
                    return 0
                case .custom(let adapter):
                    return try adapter.adapt(value, from: impl)
                }
            }
        }
    }
}

private extension CleanJSONDecoder.KeyDecodingStrategy {
    
    static func _convertFromSnakeCase(_ stringKey: String) -> String {
        guard !stringKey.isEmpty else { return stringKey }

        // Find the first non-underscore character
        guard let firstNonUnderscore = stringKey.firstIndex(where: { $0 != "_" }) else {
            // Reached the end without finding an _
            return stringKey
        }

        // Find the last non-underscore character
        var lastNonUnderscore = stringKey.index(before: stringKey.endIndex)
        while lastNonUnderscore > firstNonUnderscore && stringKey[lastNonUnderscore] == "_" {
            stringKey.formIndex(before: &lastNonUnderscore)
        }

        let keyRange = firstNonUnderscore...lastNonUnderscore
        let leadingUnderscoreRange = stringKey.startIndex..<firstNonUnderscore
        let trailingUnderscoreRange = stringKey.index(after: lastNonUnderscore)..<stringKey.endIndex

        let components = stringKey[keyRange].split(separator: "_")
        let joinedString: String
        if components.count == 1 {
            // No underscores in key, leave the word as is - maybe already camel cased
            joinedString = String(stringKey[keyRange])
        } else {
            joinedString = ([components[0].lowercased()] + components[1...].map { $0.capitalized }).joined()
        }

        // Do a cheap isEmpty check before creating and appending potentially empty strings
        let result: String
        if (leadingUnderscoreRange.isEmpty && trailingUnderscoreRange.isEmpty) {
            result = joinedString
        } else if (!leadingUnderscoreRange.isEmpty && !trailingUnderscoreRange.isEmpty) {
            // Both leading and trailing underscores
            result = String(stringKey[leadingUnderscoreRange]) + joinedString + String(stringKey[trailingUnderscoreRange])
        } else if (!leadingUnderscoreRange.isEmpty) {
            // Just leading
            result = String(stringKey[leadingUnderscoreRange]) + joinedString
        } else {
            // Just trailing
            result = joinedString + String(stringKey[trailingUnderscoreRange])
        }
        return result
    }
}
