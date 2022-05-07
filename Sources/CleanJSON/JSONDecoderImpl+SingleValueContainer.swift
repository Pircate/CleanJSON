//
//  JSONDecoderImpl+SingleValueContainer.swift
//  CleanJSON
//
//  Created by Pircate(swifter.dev@gmail.com) on 2021/12/16
//  Copyright © 2021 Pircate. All rights reserved.
//

import Foundation

extension JSONDecoderImpl {
    
    struct SingleValueContainer: SingleValueDecodingContainer {
        let impl: JSONDecoderImpl
        let value: JSONValue
        let codingPath: [CodingKey]

        init(impl: JSONDecoderImpl, codingPath: [CodingKey], json: JSONValue) {
            self.impl = impl
            self.codingPath = codingPath
            self.value = json
        }

        func decodeNil() -> Bool {
            self.value == .null
        }

        func decode(_: Bool.Type) throws -> Bool {
            guard case .bool(let bool) = self.value else {
                switch impl.options.valueNotFoundDecodingStrategy {
                case .throw:
                    throw self.impl.createTypeMismatchError(type: Bool.self, value: self.value)
                case .useDefaultValue:
                    return .defaultValue
                case .custom(let adapter):
                    return try adapter.adapt(value, from: impl)
                }
            }

            return bool
        }

        func decode(_: String.Type) throws -> String {
            guard case .string(let string) = self.value else {
                switch impl.options.valueNotFoundDecodingStrategy {
                case .throw:
                    throw self.impl.createTypeMismatchError(type: String.self, value: self.value)
                case .useDefaultValue:
                    return .defaultValue
                case .custom(let adapter):
                    return try adapter.adapt(value, from: impl)
                }
            }

            return string
        }

        func decode(_: Double.Type) throws -> Double {
            try decodeFloatingPoint()
        }

        func decode(_: Float.Type) throws -> Float {
            try decodeFloatingPoint()
        }

        func decode(_: Int.Type) throws -> Int {
            try decodeFixedWidthInteger()
        }

        func decode(_: Int8.Type) throws -> Int8 {
            try decodeFixedWidthInteger()
        }

        func decode(_: Int16.Type) throws -> Int16 {
            try decodeFixedWidthInteger()
        }

        func decode(_: Int32.Type) throws -> Int32 {
            try decodeFixedWidthInteger()
        }

        func decode(_: Int64.Type) throws -> Int64 {
            try decodeFixedWidthInteger()
        }

        func decode(_: UInt.Type) throws -> UInt {
            try decodeFixedWidthInteger()
        }

        func decode(_: UInt8.Type) throws -> UInt8 {
            try decodeFixedWidthInteger()
        }

        func decode(_: UInt16.Type) throws -> UInt16 {
            try decodeFixedWidthInteger()
        }

        func decode(_: UInt32.Type) throws -> UInt32 {
            try decodeFixedWidthInteger()
        }

        func decode(_: UInt64.Type) throws -> UInt64 {
            try decodeFixedWidthInteger()
        }

        func decode<T>(_: T.Type) throws -> T where T: Decodable {
            do {
                return try self.impl.unwrap(as: T.self)
            } catch {
                switch impl.options.valueNotFoundDecodingStrategy {
                case .throw:
                    throw error
                case .useDefaultValue, .custom:
                    return try impl.decodeAsDefaultValue()
                }
            }
        }

        @inline(__always) private func decodeFixedWidthInteger<T: FixedWidthInteger>() throws -> T {
            do {
                return try self.impl.unwrapFixedWidthInteger(from: self.value, as: T.self)
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

        @inline(__always) private func decodeFloatingPoint<T: LosslessStringConvertible & BinaryFloatingPoint>() throws -> T {
            do {
                return try self.impl.unwrapFloatingPoint(from: self.value, as: T.self)
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
