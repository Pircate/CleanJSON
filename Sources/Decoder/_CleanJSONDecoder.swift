// 
//  _CleanJSONDecoder.swift
//  CleanJSON
//
//  Created by Pircate(gao497868860@gmail.com) on 2018/10/10
//  Copyright © 2018 Pircate. All rights reserved.
//

import Foundation

class _CleanJSONDecoder: Decoder {
    
    /// The decoder's storage.
    var storage: _CleanJSONDecodingStorage
    
    /// Options set on the top-level decoder.
    let options: CleanJSONDecoder._Options
    
    /// The path to the current point in encoding.
    public var codingPath: [CodingKey]
    
    /// Contextual user-provided information for use during encoding.
    public var userInfo: [CodingUserInfoKey : Any] {
        return self.options.userInfo
    }
    
    // MARK: - Initialization
    
    /// Initializes `self` with the given top-level container and options.
    init(referencing container: Any, at codingPath: [CodingKey] = [], options: CleanJSONDecoder._Options) {
        self.storage = _CleanJSONDecodingStorage()
        self.storage.push(container: container)
        self.codingPath = codingPath
        self.options = options
    }
    
    // MARK: - Decoder Methods
    
    public func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> {
        let topContainer = self.storage.topContainer as? [String : Any] ?? [:]
        let container = _CleanJSONKeyedDecodingContainer<Key>(referencing: self, wrapping: topContainer)
        return KeyedDecodingContainer(container)
    }
    
    public func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        let topContainer = self.storage.topContainer as? [Any] ?? []
        return _CleanJSONUnkeyedDecodingContainer(referencing: self, wrapping: topContainer)
    }
    
    public func singleValueContainer() throws -> SingleValueDecodingContainer {
        return self
    }
}
