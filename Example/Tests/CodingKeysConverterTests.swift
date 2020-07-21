// 
//  CodingKeysConverterTests.swift
//  CleanJSON_Tests
//
//  Created by Pircate(swifter.dev@gmail.com) on 2020/7/21
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
import CleanJSON

struct CodingKeysModel: Codable {
    let snakeCase: String
    let nested: Nested
    let jsonString: JSONString
    
    struct Nested: Codable {
        let nestedKey: String
    }
    
    struct JSONString: Codable {
        let jsonKey: String
    }
}

class CodingKeysConverterTests: XCTestCase {

    func testExample() throws {
        let data = #"""
                    {
                        "snake_case": "value",
                        "nested": { "nested_key": "value" },
                        "json_string": "{\"json_key\":\"value\"}"
                    }
                """#.data(using: .utf8)!
        let decoder = CleanJSONDecoder()
        decoder.keyDecodingStrategy = .mapper([
            ["snake_case"]: "snakeCase",
            ["nested", "nested_key"]: "nestedKey",
            ["json_string"]: "jsonString",
            ["jsonString", "json_key"]: "jsonKey"
        ])
        decoder.jsonStringDecodingStrategy = .all
        
        let model = try! decoder.decode(CodingKeysModel.self, from: data)
        
        XCTAssertEqual(model.snakeCase, "value")
        XCTAssertEqual(model.nested.nestedKey, "value")
        XCTAssertEqual(model.jsonString.jsonKey, "value")
    }
}
