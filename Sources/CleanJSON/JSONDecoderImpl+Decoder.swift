//
//  JSONDecoderImpl+Decoder.swift
//  CleanJSON
//
//  Created by Pircate(swifter.dev@gmail.com) on 2021/12/16
//  Copyright © 2021 Pircate. All rights reserved.
//

import Foundation

private protocol _JSONStringDictionaryDecodableMarker {
    static var elementType: Decodable.Type { get }
}

extension Dictionary: _JSONStringDictionaryDecodableMarker where Key == String, Value: Decodable {
    static var elementType: Decodable.Type { return Value.self }
}

@available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
private var _iso8601Formatter: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = .withInternetDateTime
    return formatter
}()

extension JSONDecoderImpl: Decoder {
    
    @usableFromInline func container<Key>(
        keyedBy _: Key.Type
    ) throws -> KeyedDecodingContainer<Key> where Key: CodingKey {
        guard case .object(let dictionary) = self.json else {
            switch options.nestedContainerDecodingStrategy.typeMismatch {
            case .throw:
                throw DecodingError.typeMismatch(
                    [String: JSONValue].self,
                    DecodingError.Context(
                        codingPath: self.codingPath,
                        debugDescription: "Expected to decode \([String: JSONValue].self) but found \(self.json.debugDataTypeDescription) instead."
                    )
                )
            case .useEmptyContainer:
                let container = KeyedContainer<Key>(
                    impl: self,
                    codingPath: codingPath,
                    dictionary: [:]
                )
                return KeyedDecodingContainer(container)
            }
        }

        let container = KeyedContainer<Key>(
            impl: self,
            codingPath: codingPath,
            dictionary: dictionary
        )
        return KeyedDecodingContainer(container)
    }

    @usableFromInline func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        guard case .array(let array) = self.json else {
            switch options.nestedContainerDecodingStrategy.typeMismatch {
            case .throw:
                throw DecodingError.typeMismatch(
                    [JSONValue].self,
                    DecodingError.Context(
                        codingPath: self.codingPath,
                        debugDescription: "Expected to decode \([JSONValue].self) but found \(self.json.debugDataTypeDescription) instead."
                    )
                )
            case .useEmptyContainer:
                return UnkeyedContainer(
                    impl: self,
                    codingPath: self.codingPath,
                    array: []
                )
            }
        }

        return UnkeyedContainer(
            impl: self,
            codingPath: self.codingPath,
            array: array
        )
    }

    @usableFromInline func singleValueContainer() throws -> SingleValueDecodingContainer {
        SingleValueContainer(
            impl: self,
            codingPath: self.codingPath,
            json: self.json
        )
    }
    
    func decodeDictionary<T: Decodable>(as type: T.Type) throws -> T {
        do {
            return try self.unwrapDictionary(as: T.self)
        } catch {
            switch options.valueNotFoundDecodingStrategy {
            case .throw:
                throw error
            case .useDefaultValue, .custom:
                return [:] as! T
            }
        }
    }

    // MARK: Special case handling

    func unwrap<T: Decodable>(as type: T.Type) throws -> T {
        if type == Date.self {
            return try self.decodeDate() as! T
        }
        if type == Data.self {
            return try self.decodeData() as! T
        }
        if type == URL.self {
            return try self.unwrapURL() as! T
        }
        if type == Decimal.self {
            return try self.decodeDecimal() as! T
        }
        if T.self is _JSONStringDictionaryDecodableMarker.Type {
            return try self.decodeDictionary(as: T.self)
        }

        return try T(from: self)
    }

    func unwrapDate() throws -> Date {
        switch self.options.dateDecodingStrategy {
        case .deferredToDate:
            return try Date(from: self)

        case .secondsSince1970:
            let double = try unwrapFloatingPoint(from: json, for: codingPath.last, as: Double.self)
            return Date(timeIntervalSince1970: double)

        case .millisecondsSince1970:
            let double = try unwrapFloatingPoint(from: json, for: codingPath.last, as: Double.self)
            return Date(timeIntervalSince1970: double / 1000.0)

        case .iso8601:
            if #available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *) {
                let string = try unwrapString(from: json, for: codingPath.last)
                guard let date = _iso8601Formatter.date(from: string) else {
                    throw DecodingError.dataCorrupted(
                        DecodingError.Context(
                            codingPath: self.codingPath,
                            debugDescription: "Expected date string to be ISO8601-formatted."
                        )
                    )
                }

                return date
            } else {
                fatalError("ISO8601DateFormatter is unavailable on this platform.")
            }

        case .formatted(let formatter):
            let string = try unwrapString(from: json, for: codingPath.last)
            guard let date = formatter.date(from: string) else {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: self.codingPath,
                        debugDescription: "Date string does not match format expected by formatter."
                    )
                )
            }
            return date

        case .custom(let closure):
            return try closure(self)
        }
    }

    func unwrapData() throws -> Data {
        switch self.options.dataDecodingStrategy {
        case .deferredToData:
            return try Data(from: self)

        case .base64:
            let string = try unwrapString(from: json, for: codingPath.last)

            guard let data = Data(base64Encoded: string) else {
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: self.codingPath, debugDescription: "Encountered Data is not valid Base64."))
            }

            return data

        case .custom(let closure):
            return try closure(self)
        }
    }

    func unwrapURL() throws -> URL {
        let string = try unwrapString(from: json, for: codingPath.last)

        guard let url = URL(string: string) else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: self.codingPath,
                    debugDescription: "Invalid URL string."
                )
            )
        }
        return url
    }

    func unwrapDecimal() throws -> Decimal {
        guard case .number(let numberString) = self.json else {
            throw DecodingError.typeMismatch(
                Decimal.self,
                DecodingError.Context(
                    codingPath: self.codingPath,
                    debugDescription: ""
                )
            )
        }

        guard let decimal = Decimal(string: numberString) else {
            throw DecodingError.dataCorrupted(.init(
                codingPath: self.codingPath,
                debugDescription: "Parsed JSON number <\(numberString)> does not fit in \(Decimal.self)."))
        }

        return decimal
    }

    private func unwrapDictionary<T: Decodable>(as: T.Type) throws -> T {
        guard let dictType = T.self as? (_JSONStringDictionaryDecodableMarker & Decodable).Type else {
            preconditionFailure("Must only be called of T implements _JSONStringDictionaryDecodableMarker")
        }

        guard case .object(let object) = self.json else {
            throw DecodingError.typeMismatch(
                [String: JSONValue].self,
                DecodingError.Context(
                    codingPath: self.codingPath,
                    debugDescription: "Expected to decode \([String: JSONValue].self) but found \(self.json.debugDataTypeDescription) instead."
                )
            )
        }

        var result = [String: Any]()

        for (key, value) in object {
            var newPath = self.codingPath
            newPath.append(JSONKey(stringValue: key)!)
            let newDecoder = JSONDecoderImpl(
                userInfo: self.userInfo,
                from: value,
                codingPath: newPath,
                options: self.options
            )

            result[key] = try dictType.elementType.createByDirectlyUnwrapping(from: newDecoder)
        }

        return result as! T
    }
    
    func unwrapBool(from value: JSONValue, for additionalKey: CodingKey? = nil) throws -> Bool {
        if case .bool(let bool) = value {
            return bool
        }
        
        throw self.createTypeMismatchError(type: Bool.self, for: additionalKey, value: value)
    }
    
    func unwrapString(from value: JSONValue, for additionalKey: CodingKey? = nil) throws -> String {
        if case .string(let string) = value {
            return string
        }
        
        throw self.createTypeMismatchError(type: String.self, for: additionalKey, value: value)
    }

    func unwrapFloatingPoint<T: LosslessStringConvertible & BinaryFloatingPoint>(
        from value: JSONValue,
        for additionalKey: CodingKey? = nil,
        as type: T.Type) throws -> T
    {
        if case .number(let number) = value {
            guard let floatingPoint = T(number), floatingPoint.isFinite else {
                var path = self.codingPath
                if let additionalKey = additionalKey {
                    path.append(additionalKey)
                }
                throw DecodingError.dataCorrupted(.init(
                    codingPath: path,
                    debugDescription: "Parsed JSON number <\(number)> does not fit in \(T.self)."))
            }

            return floatingPoint
        }

        if case .string(let string) = value,
           case .convertFromString(let posInfString, let negInfString, let nanString) =
            self.options.nonConformingFloatDecodingStrategy
        {
            if string == posInfString {
                return T.infinity
            } else if string == negInfString {
                return -T.infinity
            } else if string == nanString {
                return T.nan
            }
        }

        throw self.createTypeMismatchError(type: T.self, for: additionalKey, value: value)
    }

    func unwrapFixedWidthInteger<T: FixedWidthInteger>(
        from value: JSONValue,
        for additionalKey: CodingKey? = nil,
        as type: T.Type) throws -> T
    {
        guard case .number(let number) = value else {
            throw self.createTypeMismatchError(type: T.self, for: additionalKey, value: value)
        }

        // this is the fast pass. Number directly convertible to Integer
        if let integer = T(number) {
            return integer
        }

        // this is the really slow path... If the fast path has failed. For example for "34.0" as
        // an integer, we try to go through NSNumber
        if let nsNumber = NSNumber.fromJSONNumber(number) {
            if type == UInt8.self, NSNumber(value: nsNumber.uint8Value) == nsNumber {
                return nsNumber.uint8Value as! T
            }
            if type == Int8.self, NSNumber(value: nsNumber.int8Value) == nsNumber {
                return nsNumber.uint8Value as! T
            }
            if type == UInt16.self, NSNumber(value: nsNumber.uint16Value) == nsNumber {
                return nsNumber.uint16Value as! T
            }
            if type == Int16.self, NSNumber(value: nsNumber.int16Value) == nsNumber {
                return nsNumber.uint16Value as! T
            }
            if type == UInt32.self, NSNumber(value: nsNumber.uint32Value) == nsNumber {
                return nsNumber.uint32Value as! T
            }
            if type == Int32.self, NSNumber(value: nsNumber.int32Value) == nsNumber {
                return nsNumber.uint32Value as! T
            }
            if type == UInt64.self, NSNumber(value: nsNumber.uint64Value) == nsNumber {
                return nsNumber.uint64Value as! T
            }
            if type == Int64.self, NSNumber(value: nsNumber.int64Value) == nsNumber {
                return nsNumber.uint64Value as! T
            }
            if type == UInt.self, NSNumber(value: nsNumber.uintValue) == nsNumber {
                return nsNumber.uintValue as! T
            }
            if type == Int.self, NSNumber(value: nsNumber.uintValue) == nsNumber {
                return nsNumber.intValue as! T
            }
        }

        var path = self.codingPath
        if let additionalKey = additionalKey {
            path.append(additionalKey)
        }
        throw DecodingError.dataCorrupted(.init(
            codingPath: path,
            debugDescription: "Parsed JSON number <\(number)> does not fit in \(T.self)."))
    }

    func createTypeMismatchError(type: Any.Type, for additionalKey: CodingKey? = nil, value: JSONValue) -> DecodingError {
        var path = self.codingPath
        if let additionalKey = additionalKey {
            path.append(additionalKey)
        }

        return DecodingError.typeMismatch(type, .init(
            codingPath: path,
            debugDescription: "Expected to decode \(type) but found \(value.debugDataTypeDescription) instead."
        ))
    }
}

private extension Decodable {
    
    static func createByDirectlyUnwrapping(from decoder: JSONDecoderImpl) throws -> Self {
        if Self.self == URL.self
            || Self.self == Date.self
            || Self.self == Data.self
            || Self.self == Decimal.self
            || Self.self is _JSONStringDictionaryDecodableMarker.Type
        {
            return try decoder.unwrap(as: Self.self)
        }

        return try Self.init(from: decoder)
    }
}

private extension JSONDecoderImpl {
    
    func decodeDate() throws -> Date {
        do {
            return try unwrapDate()
        } catch {
            switch options.valueNotFoundDecodingStrategy {
            case .throw:
                throw error
            case .useDefaultValue:
                return .defaultValue(for: options.dateDecodingStrategy)
            case .custom(let adapter):
                return try adapter.adapt(json, from: self)
            }
        }
    }
    
    func decodeData() throws -> Data {
        do {
            return try unwrapData()
        } catch {
            switch options.valueNotFoundDecodingStrategy {
            case .throw:
                throw error
            case .useDefaultValue:
                return .defaultValue
            case .custom(let adapter):
                return try adapter.adapt(json, from: self)
            }
        }
    }
    
    func decodeDecimal() throws -> Decimal {
        do {
            return try unwrapDecimal()
        } catch {
            switch options.valueNotFoundDecodingStrategy {
            case .throw:
                throw error
            case .useDefaultValue:
                return .defaultValue
            case .custom(let adapter):
                return try adapter.adapt(json, from: self)
            }
        }
    }
}
