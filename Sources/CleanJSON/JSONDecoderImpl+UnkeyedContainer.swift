//
//  JSONDecoderImpl+UnkeyedContainer.swift
//  CleanJSON
//
//  Created by Pircate(swifter.dev@gmail.com) on 2021/12/16
//  Copyright © 2021 Pircate. All rights reserved.
//

import Foundation

extension JSONDecoderImpl {
    
    struct UnkeyedContainer: UnkeyedDecodingContainer {
        let impl: JSONDecoderImpl
        let codingPath: [CodingKey]
        let array: [JSONValue]

        var count: Int? { self.array.count }
        var isAtEnd: Bool { self.currentIndex >= (self.count ?? 0) }
        var currentIndex = 0

        init(impl: JSONDecoderImpl, codingPath: [CodingKey], array: [JSONValue]) {
            self.impl = impl
            self.codingPath = codingPath
            self.array = array
        }

        mutating func decodeNil() throws -> Bool {
            if try self.getNextValue(ofType: Never.self) == .null {
                self.currentIndex += 1
                return true
            }

            // The protocol states:
            //   If the value is not null, does not increment currentIndex.
            return false
        }

        mutating func decode(_ type: Bool.Type) throws -> Bool {
            let value = try self.getNextValue(ofType: Bool.self)
            guard case .bool(let bool) = value else {
                switch impl.options.valueNotFoundDecodingStrategy {
                case .throw:
                    throw impl.createTypeMismatchError(
                        type: type,
                        for: JSONKey(index: currentIndex),
                        value: value
                    )
                case .useDefaultValue:
                    self.currentIndex += 1
                    return .defaultValue
                case .custom(let adapter):
                    self.currentIndex += 1
                    return try adapter.adapt(value, from: impl)
                }
            }

            self.currentIndex += 1
            return bool
        }

        mutating func decode(_ type: String.Type) throws -> String {
            let value = try self.getNextValue(ofType: String.self)
            guard case .string(let string) = value else {
                switch impl.options.valueNotFoundDecodingStrategy {
                case .throw:
                    throw impl.createTypeMismatchError(
                        type: type,
                        for: JSONKey(index: currentIndex),
                        value: value
                    )
                case .useDefaultValue:
                    self.currentIndex += 1
                    return .defaultValue
                case .custom(let adapter):
                    self.currentIndex += 1
                    return try adapter.adapt(value, from: impl)
                }
            }

            self.currentIndex += 1
            return string
        }

        mutating func decode(_: Double.Type) throws -> Double {
            try decodeFloatingPoint()
        }

        mutating func decode(_: Float.Type) throws -> Float {
            try decodeFloatingPoint()
        }

        mutating func decode(_: Int.Type) throws -> Int {
            try decodeFixedWidthInteger()
        }

        mutating func decode(_: Int8.Type) throws -> Int8 {
            try decodeFixedWidthInteger()
        }

        mutating func decode(_: Int16.Type) throws -> Int16 {
            try decodeFixedWidthInteger()
        }

        mutating func decode(_: Int32.Type) throws -> Int32 {
            try decodeFixedWidthInteger()
        }

        mutating func decode(_: Int64.Type) throws -> Int64 {
            try decodeFixedWidthInteger()
        }

        mutating func decode(_: UInt.Type) throws -> UInt {
            try decodeFixedWidthInteger()
        }

        mutating func decode(_: UInt8.Type) throws -> UInt8 {
            try decodeFixedWidthInteger()
        }

        mutating func decode(_: UInt16.Type) throws -> UInt16 {
            try decodeFixedWidthInteger()
        }

        mutating func decode(_: UInt32.Type) throws -> UInt32 {
            try decodeFixedWidthInteger()
        }

        mutating func decode(_: UInt64.Type) throws -> UInt64 {
            try decodeFixedWidthInteger()
        }

        mutating func decode<T>(_: T.Type) throws -> T where T: Decodable {
            let newDecoder = try decoderForNextElement(ofType: T.self)
            let result: T
            
            do {
                result = try newDecoder.unwrap(as: T.self)
            } catch {
                switch impl.options.valueNotFoundDecodingStrategy {
                case .throw:
                    throw error
                case .useDefaultValue, .custom:
                    result = try newDecoder.decodeAsDefaultValue()
                }
            }

            // Because of the requirement that the index not be incremented unless
            // decoding the desired result type succeeds, it can not be a tail call.
            // Hopefully the compiler still optimizes well enough that the result
            // doesn't get copied around.
            self.currentIndex += 1
            return result
        }

        mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws
            -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey
        {
            let decoder = try decoderForNextElement(ofType: KeyedDecodingContainer<NestedKey>.self)
            let container = try decoder.container(keyedBy: type)

            self.currentIndex += 1
            return container
        }

        mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
            let decoder = try decoderForNextElement(ofType: UnkeyedDecodingContainer.self)
            let container = try decoder.unkeyedContainer()

            self.currentIndex += 1
            return container
        }

        mutating func superDecoder() throws -> Decoder {
            let decoder = try decoderForNextElement(ofType: Decoder.self)
            self.currentIndex += 1
            return decoder
        }

        mutating func decoderForNextElement<T>(ofType: T.Type) throws -> JSONDecoderImpl {
            let value = try self.getNextValue(ofType: T.self)
            let newPath = self.codingPath + [JSONKey(index: self.currentIndex)]

            return JSONDecoderImpl(
                userInfo: self.impl.userInfo,
                from: value,
                codingPath: newPath,
                options: self.impl.options
            )
        }

        @inline(__always)
        func getNextValue<T>(ofType: T.Type) throws -> JSONValue {
            guard !self.isAtEnd else {
                var message = "Unkeyed container is at end."
                if T.self == UnkeyedContainer.self {
                    message = "Cannot get nested unkeyed container -- unkeyed container is at end."
                }
                if T.self == Decoder.self {
                    message = "Cannot get superDecoder() -- unkeyed container is at end."
                }

                var path = self.codingPath
                path.append(JSONKey(index: self.currentIndex))

                throw DecodingError.valueNotFound(
                    T.self,
                    .init(codingPath: path,
                          debugDescription: message,
                          underlyingError: nil))
            }
            return self.array[self.currentIndex]
        }

        @inline(__always) private mutating func decodeFixedWidthInteger<T: FixedWidthInteger>() throws -> T {
            let value = try self.getNextValue(ofType: T.self)
            let key = JSONKey(index: self.currentIndex)
            
            do {
                let result = try self.impl.unwrapFixedWidthInteger(from: value, for: key, as: T.self)
                self.currentIndex += 1
                return result
            } catch {
                switch impl.options.valueNotFoundDecodingStrategy {
                case .throw:
                    throw error
                case .useDefaultValue:
                    self.currentIndex += 1
                    return 0
                case .custom(let adapter):
                    self.currentIndex += 1
                    return try adapter.adapt(value, from: impl)
                }
            }
        }

        @inline(__always) private mutating func decodeFloatingPoint<T: LosslessStringConvertible & BinaryFloatingPoint>() throws -> T {
            let value = try self.getNextValue(ofType: T.self)
            let key = JSONKey(index: self.currentIndex)
            do {
                let result = try self.impl.unwrapFloatingPoint(from: value, for: key, as: T.self)
                self.currentIndex += 1
                return result
            } catch {
                switch impl.options.valueNotFoundDecodingStrategy {
                case .throw:
                    throw error
                case .useDefaultValue:
                    self.currentIndex += 1
                    return 0
                case .custom(let adapter):
                    self.currentIndex += 1
                    return try adapter.adapt(value, from: impl)
                }
            }
        }
    }
}
