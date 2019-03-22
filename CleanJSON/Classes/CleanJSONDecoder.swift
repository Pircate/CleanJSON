// 
//  CleanJSONDecoder.swift
//  CleanJSON
//
//  Created by Pircate(swifter.dev@gmail.com) on 2018/10/10
//  Copyright © 2018 Pircate. All rights reserved.
//

import Foundation

open class CleanJSONDecoder: JSONDecoder {
    
    /// Options set on the top-level encoder to pass down the decoding hierarchy.
    struct _Options {
        let dateDecodingStrategy: DateDecodingStrategy
        let dataDecodingStrategy: DataDecodingStrategy
        let nonConformingFloatDecodingStrategy: NonConformingFloatDecodingStrategy
        let keyDecodingStrategy: KeyDecodingStrategy
        let keyNotFoundDecodingStrategy: KeyNotFoundDecodingStrategy
        let valueNotFoundDecodingStrategy: ValueNotFoundDecodingStrategy
        let nestedContainerDecodingStrategy: NestedContainerDecodingStrategy
        let userInfo: [CodingUserInfoKey : Any]
    }
    
    /// The options set on the top-level decoder.
    var options: _Options {
        return _Options(dateDecodingStrategy: dateDecodingStrategy,
                        dataDecodingStrategy: dataDecodingStrategy,
                        nonConformingFloatDecodingStrategy: nonConformingFloatDecodingStrategy,
                        keyDecodingStrategy: keyDecodingStrategy,
                        keyNotFoundDecodingStrategy: keyNotFoundDecodingStrategy,
                        valueNotFoundDecodingStrategy: valueNotFoundDecodingStrategy,
                        nestedContainerDecodingStrategy: nestedContainerDecodingStrategy,
                        userInfo: userInfo)
    }
    
    /// The strategy to use for decoding when key not found. Defaults to `.useDefaultValue`.
    open var keyNotFoundDecodingStrategy: KeyNotFoundDecodingStrategy = .useDefaultValue
    
    /// The strategy to use for decoding when value not found. Defaults to `.custom`.
    open var valueNotFoundDecodingStrategy: ValueNotFoundDecodingStrategy = .custom(Adapter())
    
    /// The strategy to use for decoding nested container.
    open var nestedContainerDecodingStrategy: NestedContainerDecodingStrategy = .init()
    
    // MARK: - Decoding Values
    
    /// Decodes a top-level value of the given type from the given JSON representation.
    ///
    /// - parameter type: The type of the value to decode.
    /// - parameter data: The data to decode from.
    /// - returns: A value of the requested type.
    /// - throws: `DecodingError.dataCorrupted` if values requested from the payload are corrupted, or if the given data is not valid JSON.
    /// - throws: An error if any value throws an error during decoding.
    open override func decode<T : Decodable>(_ type: T.Type, from data: Data) throws -> T {
        let topLevel: Any
        do {
            topLevel = try JSONSerialization.jsonObject(with: data)
        } catch {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "The given data was not valid JSON.", underlyingError: error))
        }
        
        let decoder = _CleanJSONDecoder(referencing: topLevel, options: self.options)
        guard let value = try decoder.unbox(topLevel, as: type) else {
            throw DecodingError.valueNotFound(type, DecodingError.Context(codingPath: [], debugDescription: "The given data did not contain a top-level value."))
        }
        
        return value
    }
}
