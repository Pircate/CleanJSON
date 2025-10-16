// 
//  CleanJSONDecoder.swift
//  CleanJSON
//
//  Created by Pircate(swifter.dev@gmail.com) on 2018/10/10
//  Copyright © 2018 Pircate. All rights reserved.
//

import Foundation

public protocol JSONContainerConvertible {
    func asJSONContainer() -> Any
}

extension Dictionary: JSONContainerConvertible where Key == String, Value == Any {
    public func asJSONContainer() -> Any { self }
}

extension Array: JSONContainerConvertible where Element == Any {
    public func asJSONContainer() -> Any { self }
}

open class CleanJSONDecoder: JSONDecoder, @unchecked Sendable {
    
    /// Options set on the top-level encoder to pass down the decoding hierarchy.
    struct Options {
        let dateDecodingStrategy: DateDecodingStrategy
        let dataDecodingStrategy: DataDecodingStrategy
        let nonConformingFloatDecodingStrategy: NonConformingFloatDecodingStrategy
        let keyDecodingStrategy: KeyDecodingStrategy
        let keyNotFoundDecodingStrategy: KeyNotFoundDecodingStrategy
        let valueNotFoundDecodingStrategy: ValueNotFoundDecodingStrategy
        let nestedContainerDecodingStrategy: NestedContainerDecodingStrategy
        let jsonStringDecodingStrategy: JSONStringDecodingStrategy
        let userInfo: [CodingUserInfoKey: Any]
    }
    
    /// The options set on the top-level decoder.
    var options: Options {
        return Options(
            dateDecodingStrategy: dateDecodingStrategy,
            dataDecodingStrategy: dataDecodingStrategy,
            nonConformingFloatDecodingStrategy: nonConformingFloatDecodingStrategy,
            keyDecodingStrategy: keyDecodingStrategy,
            keyNotFoundDecodingStrategy: keyNotFoundDecodingStrategy,
            valueNotFoundDecodingStrategy: valueNotFoundDecodingStrategy,
            nestedContainerDecodingStrategy: nestedContainerDecodingStrategy,
            jsonStringDecodingStrategy: jsonStringDecodingStrategy,
            userInfo: userInfo
        )
    }
    
    /// The strategy to use for decoding when key not found. Defaults to `.useDefaultValue`.
    open var keyNotFoundDecodingStrategy: KeyNotFoundDecodingStrategy = .useDefaultValue
    
    /// The strategy to use for decoding when value not found. Defaults to `.custom`.
    open var valueNotFoundDecodingStrategy: ValueNotFoundDecodingStrategy = .custom(Adapter())
    
    /// The strategy to use for decoding nested container.
    open var nestedContainerDecodingStrategy: NestedContainerDecodingStrategy = .init()
    
    /// The strategy to use for decoding JSON string.
    open var jsonStringDecodingStrategy: JSONStringDecodingStrategy = .containsKeys([])
    
    // MARK: - Decoding Values
    
    /// Decodes a top-level value of the given type from the given JSON representation.
    ///
    /// - parameter type: The type of the value to decode.
    /// - parameter data: The data to decode from.
    /// - returns: A value of the requested type.
    /// - throws: `DecodingError.dataCorrupted` if values requested from the payload are corrupted, or if the given data is not valid JSON.
    /// - throws: An error if any value throws an error during decoding.
    open override func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        let topLevel: Any
        do {
            topLevel = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
        } catch {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: [],
                    debugDescription: "The given data was not valid JSON.",
                    underlyingError: error
                )
            )
        }
        
        return try decode(type, from: topLevel)
    }
    
    /// Decodes a top-level value of the given type.
    ///
    /// - parameter type: The type of the value to decode.
    /// - parameter convertible: The container to decode from.
    /// - returns: A value of the requested type.
    /// - throws: An error if any value throws an error during decoding.
    open func decode<T: Decodable>(
        _ type: T.Type,
        from convertible: JSONContainerConvertible
    ) throws -> T {
        try decode(type, from: convertible.asJSONContainer())
    }
}

private extension CleanJSONDecoder {
    
    func decode<T: Decodable>(
        _ type: T.Type,
        from container: Any
    ) throws -> T {
        let decoder = _CleanJSONDecoder(referencing: container, options: self.options)
        
        guard let value = try decoder.unbox(container, as: type) else {
            throw DecodingError.valueNotFound(
                type,
                DecodingError.Context(
                    codingPath: [],
                    debugDescription: "The given data did not contain a top-level value."
                )
            )
        }
        
        return value
    }
}

// Add an internal empty type in the CleanJSON framework to skip elements
private struct _CleanJSONSkip: Decodable { }

// Extend KeyedDecodingContainer to add special decoding for array types
public extension KeyedDecodingContainer {
    func decode<Element: Decodable>(_ type: [Element].Type, forKey key: Key) throws -> [Element] {
        // If the key does not exist or its value is null, return an empty array (without throwing an error)
        guard contains(key), (try? decodeNil(forKey: key)) == false else {
            return []
        }
        var container = try nestedUnkeyedContainer(forKey: key)
        var result: [Element] = []
        // Iterate through the unkeyed container and decode each element
        while !container.isAtEnd {
            if let element = try? container.decode(Element.self) {
                result.append(element)  // Successfully decoded, add to the result
            } else {
                // Decoding failed, skip the current element:
                _ = try? container.decode(_CleanJSONSkip.self)
                // ↑ Decode into an empty Decodable type to discard the invalid element
            }
        }
        return result
    }

    func decodeIfPresent<Element: Decodable>(_ type: [Element].Type, forKey key: Key) throws -> [Element]? {
        // If the key does not exist or its value is null, return nil indicating the absence of this array
        guard contains(key), (try? decodeNil(forKey: key)) == false else {
            return nil
        }
        return try decode([Element].self, forKey: key)  // Call the decode implementation above
    }
}
