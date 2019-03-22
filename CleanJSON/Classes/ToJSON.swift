//
//  ToJSON.swift
//  CleanJSON
//
//  Created by Pircate(swifter.dev@gmail.com) on 2018/10/23
//  Copyright © 2018 Pircate. All rights reserved.
//

public extension Encodable {
    
    func toJSON(using encoder: JSONEncoder = .init()) throws -> Data {
        return try encoder.encode(self)
    }
    
    func toJSONString(using encoder: JSONEncoder = .init()) throws -> String? {
        return String(data: try toJSON(using: encoder), encoding: .utf8)
    }
}
