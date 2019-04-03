// 
//  _CleanJSONKeyedDecodingContainer.swift
//  CleanJSON
//
//  Created by Pircate(swifter.dev@gmail.com) on 2018/10/10
//  Copyright © 2018 Pircate. All rights reserved.
//

import Foundation

struct _CleanJSONKeyedDecodingContainer<K : CodingKey>: KeyedDecodingContainerProtocol {
    
    typealias Key = K
    
    // MARK: Properties
    
    /// A reference to the decoder we're reading from.
    private let decoder: _CleanJSONDecoder
    
    /// A reference to the container we're reading from.
    private let container: [String : Any]
    
    /// The path of coding keys taken to get to this point in decoding.
    private(set) public var codingPath: [CodingKey]
    
    // MARK: - Initialization
    
    /// Initializes `self` by referencing the given decoder and container.
    init(referencing decoder: _CleanJSONDecoder, wrapping container: [String : Any]) {
        self.decoder = decoder
        switch decoder.options.keyDecodingStrategy {
        case .useDefaultKeys:
            self.container = container
        case .convertFromSnakeCase:
            // Convert the snake case keys in the container to camel case.
            // If we hit a duplicate key after conversion, then we'll use the first one we saw. Effectively an undefined behavior with JSON dictionaries.
            self.container = Dictionary(container.map {
                dict in (CleanJSONDecoder.KeyDecodingStrategy._convertFromSnakeCase(dict.key), dict.value)
            }, uniquingKeysWith: { (first, _) in first })
        case .custom(let converter):
            self.container = Dictionary(container.map {
                key, value in (converter(decoder.codingPath + [_CleanJSONKey(stringValue: key, intValue: nil)]).stringValue, value)
            }, uniquingKeysWith: { (first, _) in first })
        @unknown default:
            self.container = container
        }
        self.codingPath = decoder.codingPath
    }
    
    // MARK: - KeyedDecodingContainerProtocol Methods
    
    public var allKeys: [Key] {
        return self.container.keys.compactMap { Key(stringValue: $0) }
    }
    
    public func contains(_ key: Key) -> Bool {
        return self.container[key.stringValue] != nil
    }
    
    public func decodeNil(forKey key: Key) throws -> Bool {
        guard let entry = self.container[key.stringValue] else {
            throw DecodingError.Keyed.keyNotFound(key, codingPath: decoder.codingPath)
        }
        
        return entry is NSNull
    }
    
    public func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
        guard let entry = self.container[key.stringValue] else {
            return try decodeIfKeyNotFound(key)
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(entry, as: Bool.self) else {
            switch decoder.options.valueNotFoundDecodingStrategy {
            case .throw:
                throw DecodingError.Keyed.valueNotFound(type, codingPath: decoder.codingPath)
            case .useDefaultValue:
                return Bool.defaultValue
            case .custom(let adapter):
                decoder.storage.push(container: entry)
                defer { decoder.storage.popContainer() }
                return try adapter.adapt(decoder)
            }
        }
        
        return value
    }
    
    public func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
        guard let entry = self.container[key.stringValue] else {
            return try decodeIfKeyNotFound(key)
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(entry, as: Int.self) else {
            switch decoder.options.valueNotFoundDecodingStrategy {
            case .throw:
                throw DecodingError.Keyed.valueNotFound(type, codingPath: decoder.codingPath)
            case .useDefaultValue:
                return Int.defaultValue
            case .custom(let adapter):
                decoder.storage.push(container: entry)
                defer { decoder.storage.popContainer() }
                return try adapter.adapt(decoder)
            }
        }
        
        return value
    }
    
    public func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
        guard let entry = self.container[key.stringValue] else {
            return try decodeIfKeyNotFound(key)
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(entry, as: Int8.self) else {
            switch decoder.options.valueNotFoundDecodingStrategy {
            case .throw:
                throw DecodingError.Keyed.valueNotFound(type, codingPath: decoder.codingPath)
            case .useDefaultValue:
                return Int8.defaultValue
            case .custom(let adapter):
                decoder.storage.push(container: entry)
                defer { decoder.storage.popContainer() }
                return try adapter.adapt(decoder)
            }
        }
        
        return value
    }
    
    public func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
        guard let entry = self.container[key.stringValue] else {
            return try decodeIfKeyNotFound(key)
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(entry, as: Int16.self) else {
            switch decoder.options.valueNotFoundDecodingStrategy {
            case .throw:
                throw DecodingError.Keyed.valueNotFound(type, codingPath: decoder.codingPath)
            case .useDefaultValue:
                return Int16.defaultValue
            case .custom(let adapter):
                decoder.storage.push(container: entry)
                defer { decoder.storage.popContainer() }
                return try adapter.adapt(decoder)
            }
        }
        
        return value
    }
    
    public func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
        guard let entry = self.container[key.stringValue] else {
            return try decodeIfKeyNotFound(key)
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(entry, as: Int32.self) else {
            switch decoder.options.valueNotFoundDecodingStrategy {
            case .throw:
                throw DecodingError.Keyed.valueNotFound(type, codingPath: decoder.codingPath)
            case .useDefaultValue:
                return Int32.defaultValue
            case .custom(let adapter):
                decoder.storage.push(container: entry)
                defer { decoder.storage.popContainer() }
                return try adapter.adapt(decoder)
            }
        }
        
        return value
    }
    
    public func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
        guard let entry = self.container[key.stringValue] else {
            return try decodeIfKeyNotFound(key)
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(entry, as: Int64.self) else {
            switch decoder.options.valueNotFoundDecodingStrategy {
            case .throw:
                throw DecodingError.Keyed.valueNotFound(type, codingPath: decoder.codingPath)
            case .useDefaultValue:
                return Int64.defaultValue
            case .custom(let adapter):
                decoder.storage.push(container: entry)
                defer { decoder.storage.popContainer() }
                return try adapter.adapt(decoder)
            }
        }
        
        return value
    }
    
    public func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
        guard let entry = self.container[key.stringValue] else {
            return try decodeIfKeyNotFound(key)
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(entry, as: UInt.self) else {
            switch decoder.options.valueNotFoundDecodingStrategy {
            case .throw:
                throw DecodingError.Keyed.valueNotFound(type, codingPath: decoder.codingPath)
            case .useDefaultValue:
                return UInt.defaultValue
            case .custom(let adapter):
                decoder.storage.push(container: entry)
                defer { decoder.storage.popContainer() }
                return try adapter.adapt(decoder)
            }
        }
        
        return value
    }
    
    public func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
        guard let entry = self.container[key.stringValue] else {
            return try decodeIfKeyNotFound(key)
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(entry, as: UInt8.self) else {
            switch decoder.options.valueNotFoundDecodingStrategy {
            case .throw:
                throw DecodingError.Keyed.valueNotFound(type, codingPath: decoder.codingPath)
            case .useDefaultValue:
                return UInt8.defaultValue
            case .custom(let adapter):
                decoder.storage.push(container: entry)
                defer { decoder.storage.popContainer() }
                return try adapter.adapt(decoder)
            }
        }
        
        return value
    }
    
    public func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
        guard let entry = self.container[key.stringValue] else {
            return try decodeIfKeyNotFound(key)
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(entry, as: UInt16.self) else {
            switch decoder.options.valueNotFoundDecodingStrategy {
            case .throw:
                throw DecodingError.Keyed.valueNotFound(type, codingPath: decoder.codingPath)
            case .useDefaultValue:
                return UInt16.defaultValue
            case .custom(let adapter):
                decoder.storage.push(container: entry)
                defer { decoder.storage.popContainer() }
                return try adapter.adapt(decoder)
            }
        }
        
        return value
    }
    
    public func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
        guard let entry = self.container[key.stringValue] else {
            return try decodeIfKeyNotFound(key)
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(entry, as: UInt32.self) else {
            switch decoder.options.valueNotFoundDecodingStrategy {
            case .throw:
                throw DecodingError.Keyed.valueNotFound(type, codingPath: decoder.codingPath)
            case .useDefaultValue:
                return UInt32.defaultValue
            case .custom(let adapter):
                decoder.storage.push(container: entry)
                defer { decoder.storage.popContainer() }
                return try adapter.adapt(decoder)
            }
        }
        
        return value
    }
    
    public func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
        guard let entry = self.container[key.stringValue] else {
            return try decodeIfKeyNotFound(key)
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(entry, as: UInt64.self) else {
            switch decoder.options.valueNotFoundDecodingStrategy {
            case .throw:
                throw DecodingError.Keyed.valueNotFound(type, codingPath: decoder.codingPath)
            case .useDefaultValue:
                return UInt64.defaultValue
            case .custom(let adapter):
                decoder.storage.push(container: entry)
                defer { decoder.storage.popContainer() }
                return try adapter.adapt(decoder)
            }
        }
        
        return value
    }
    
    public func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
        guard let entry = self.container[key.stringValue] else {
            return try decodeIfKeyNotFound(key)
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(entry, as: Float.self) else {
            switch decoder.options.valueNotFoundDecodingStrategy {
            case .throw:
                throw DecodingError.Keyed.valueNotFound(type, codingPath: decoder.codingPath)
            case .useDefaultValue:
                return Float.defaultValue
            case .custom(let adapter):
                decoder.storage.push(container: entry)
                defer { decoder.storage.popContainer() }
                return try adapter.adapt(decoder)
            }
        }
        
        return value
    }
    
    public func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
        guard let entry = self.container[key.stringValue] else {
            return try decodeIfKeyNotFound(key)
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(entry, as: Double.self) else {
            switch decoder.options.valueNotFoundDecodingStrategy {
            case .throw:
                throw DecodingError.Keyed.valueNotFound(type, codingPath: decoder.codingPath)
            case .useDefaultValue:
                return Double.defaultValue
            case .custom(let adapter):
                decoder.storage.push(container: entry)
                defer { decoder.storage.popContainer() }
                return try adapter.adapt(decoder)
            }
        }
        
        return value
    }
    
    public func decode(_ type: String.Type, forKey key: Key) throws -> String {
        guard let entry = self.container[key.stringValue] else {
            return try decodeIfKeyNotFound(key)
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(entry, as: String.self) else {
            switch decoder.options.valueNotFoundDecodingStrategy {
            case .throw:
                throw DecodingError.Keyed.valueNotFound(type, codingPath: decoder.codingPath)
            case .useDefaultValue:
                return String.defaultValue
            case .custom(let adapter):
                decoder.storage.push(container: entry)
                defer { decoder.storage.popContainer() }
                return try adapter.adapt(decoder)
            }
        }
        
        return value
    }
    
    public func decode<T : Decodable>(_ type: T.Type, forKey key: Key) throws -> T {
        guard let entry = container[key.stringValue] else {
            switch decoder.options.keyNotFoundDecodingStrategy {
            case .throw:
                throw DecodingError.Keyed.keyNotFound(key, codingPath: decoder.codingPath)
            case .useDefaultValue:
                return try decoder.decodeUsingDefaultValue()
            }
        }
        
        decoder.codingPath.append(key)
        defer { decoder.codingPath.removeLast() }
        
        guard let value = try decoder.unbox(entry, as: type) else {
            switch decoder.options.valueNotFoundDecodingStrategy {
            case .throw:
                throw DecodingError.Keyed.valueNotFound(type, codingPath: decoder.codingPath)
            case .useDefaultValue:
                return try decoder.decodeUsingDefaultValue()
            case .custom:
                decoder.storage.push(container: entry)
                defer { decoder.storage.popContainer() }
                return try decoder.decode(type)
            }
        }
        
        return value
    }
    
    public func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> {
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = self.container[key.stringValue] else {
            switch decoder.options.nestedContainerDecodingStrategy.keyNotFound {
            case .throw:
                throw DecodingError.Nested.keyNotFound(key, codingPath: codingPath)
            case .useEmptyContainer:
                return nestedContainer()
            }
        }
        
        guard let dictionary = value as? [String : Any] else {
            switch decoder.options.nestedContainerDecodingStrategy.typeMismatch {
            case .throw:
                throw DecodingError._typeMismatch(
                    at: self.codingPath,
                    expectation: [String : Any].self,
                    reality: value)
            case .useEmptyContainer:
                return nestedContainer()
            }
        }
        
        return nestedContainer(wrapping: dictionary)
    }
    
    private func nestedContainer<NestedKey>(wrapping dictionary: [String: Any] = [:])
        -> KeyedDecodingContainer<NestedKey> {
        let container = _CleanJSONKeyedDecodingContainer<NestedKey>(
            referencing: decoder,
            wrapping: dictionary)
        return KeyedDecodingContainer(container)
    }
    
    public func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = self.container[key.stringValue] else {
            switch decoder.options.nestedContainerDecodingStrategy.keyNotFound {
            case .throw:
                throw DecodingError.Nested.keyNotFound(key, codingPath: codingPath, isUnkeyed: true)
            case .useEmptyContainer:
                return _CleanJSONUnkeyedDecodingContainer(referencing: self.decoder, wrapping: [])
            }
        }
        
        guard let array = value as? [Any] else {
            switch decoder.options.nestedContainerDecodingStrategy.typeMismatch {
            case .throw:
                throw DecodingError._typeMismatch(
                    at: self.codingPath,
                    expectation: [Any].self, reality: value)
            case .useEmptyContainer:
                return _CleanJSONUnkeyedDecodingContainer(referencing: self.decoder, wrapping: [])
            }
        }
        
        return _CleanJSONUnkeyedDecodingContainer(referencing: self.decoder, wrapping: array)
    }
    
    private func _superDecoder(forKey key: CodingKey) throws -> Decoder {
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        let value: Any = self.container[key.stringValue] ?? NSNull()
        return _CleanJSONDecoder(referencing: value, at: self.decoder.codingPath, options: self.decoder.options)
    }
    
    public func superDecoder() throws -> Decoder {
        return try _superDecoder(forKey: _CleanJSONKey.super)
    }
    
    public func superDecoder(forKey key: Key) throws -> Decoder {
        return try _superDecoder(forKey: key)
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
        
        var components = stringKey[keyRange].split(separator: "_")
        let joinedString : String
        if components.count == 1 {
            // No underscores in key, leave the word as is - maybe already camel cased
            joinedString = String(stringKey[keyRange])
        } else {
            joinedString = ([components[0].lowercased()] + components[1...].map { $0.capitalized }).joined()
        }
        
        // Do a cheap isEmpty check before creating and appending potentially empty strings
        let result : String
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

private extension _CleanJSONKeyedDecodingContainer {
    
    func decodeIfKeyNotFound<T>(_ key: Key) throws -> T where T: Decodable, T: Defaultable {
        switch decoder.options.keyNotFoundDecodingStrategy {
        case .throw:
            throw DecodingError.Keyed.keyNotFound(key, codingPath: decoder.codingPath)
        case .useDefaultValue:
            return T.defaultValue
        }
    }
}

extension _CleanJSONDecoder {
    
    func decodeUsingDefaultValue<T: Decodable>() throws -> T {
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
        } else if let date = Date.defaultValue as? T {
            return date
        } else if let decimal = Decimal.defaultValue as? T {
            return decimal
        } else if let object = try? unbox("{}", as: T.self) {
            return object
        }
        
        let context = DecodingError.Context(
            codingPath: codingPath,
            debugDescription: "Key: <\(codingPath)> cannot be decoded")
        throw DecodingError.dataCorrupted(context)
    }
}

extension _CleanJSONKeyedDecodingContainer {
    
    func decodeIfPresent(_ type: Bool.Type, forKey key: K) throws -> Bool? {
        if try keyOrValueNotFount(forKey: key) { return nil }
        
        return try decoder.unbox(container[key.stringValue] as Any, as: type)
    }
    
    func decodeIfPresent(_ type: Int.Type, forKey key: K) throws -> Int? {
        if try keyOrValueNotFount(forKey: key) { return nil }
        
        return try decoder.unbox(container[key.stringValue] as Any, as: type)
    }
    
    func decodeIfPresent(_ type: Int8.Type, forKey key: K) throws -> Int8? {
        if try keyOrValueNotFount(forKey: key) { return nil }
        
        return try decoder.unbox(container[key.stringValue] as Any, as: type)
    }
    
    func decodeIfPresent(_ type: Int16.Type, forKey key: K) throws -> Int16? {
        if try keyOrValueNotFount(forKey: key) { return nil }
        
        return try decoder.unbox(container[key.stringValue] as Any, as: type)
    }
    
    func decodeIfPresent(_ type: Int32.Type, forKey key: K) throws -> Int32? {
        if try keyOrValueNotFount(forKey: key) { return nil }
        
        return try decoder.unbox(container[key.stringValue] as Any, as: type)
    }
    
    func decodeIfPresent(_ type: Int64.Type, forKey key: K) throws -> Int64? {
        if try keyOrValueNotFount(forKey: key) { return nil }
        
        return try decoder.unbox(container[key.stringValue] as Any, as: type)
    }
    
    func decodeIfPresent(_ type: UInt.Type, forKey key: K) throws -> UInt? {
        if try keyOrValueNotFount(forKey: key) { return nil }
        
        return try decoder.unbox(container[key.stringValue] as Any, as: type)
    }
    
    func decodeIfPresent(_ type: UInt8.Type, forKey key: K) throws -> UInt8? {
        if try keyOrValueNotFount(forKey: key) { return nil }
        
        return try decoder.unbox(container[key.stringValue] as Any, as: type)
    }
    
    func decodeIfPresent(_ type: UInt16.Type, forKey key: K) throws -> UInt16? {
        if try keyOrValueNotFount(forKey: key) { return nil }
        
        return try decoder.unbox(container[key.stringValue] as Any, as: type)
    }
    
    func decodeIfPresent(_ type: UInt32.Type, forKey key: K) throws -> UInt32? {
        if try keyOrValueNotFount(forKey: key) { return nil }
        
        return try decoder.unbox(container[key.stringValue] as Any, as: type)
    }
    
    func decodeIfPresent(_ type: UInt64.Type, forKey key: K) throws -> UInt64? {
        if try keyOrValueNotFount(forKey: key) { return nil }
        
        return try decoder.unbox(container[key.stringValue] as Any, as: type)
    }
    
    func decodeIfPresent(_ type: Float.Type, forKey key: K) throws -> Float? {
        if try keyOrValueNotFount(forKey: key) { return nil }
        
        return try decoder.unbox(container[key.stringValue] as Any, as: type)
    }
    
    func decodeIfPresent(_ type: Double.Type, forKey key: K) throws -> Double? {
        if try keyOrValueNotFount(forKey: key) { return nil }
        
        return try decoder.unbox(container[key.stringValue] as Any, as: type)
    }

    func decodeIfPresent(_ type: String.Type, forKey key: K) throws -> String? {
        if try keyOrValueNotFount(forKey: key) { return nil }
        
        return try decoder.unbox(container[key.stringValue] as Any, as: type)
    }
    
    func decodeIfPresent<T>(_ type: T.Type, forKey key: K) throws -> T? where T : Decodable {
        if try keyOrValueNotFount(forKey: key) { return nil }
        
        return try decoder.unbox(container[key.stringValue] as Any, as: type)
    }
    
    private func keyOrValueNotFount(forKey key: K) throws -> Bool {
        guard contains(key) else { return true }
        
        if try decodeNil(forKey: key) { return true }
        
        return false
    }
}
