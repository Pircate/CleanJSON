//
//  CleanJSONTests.swift
//  CleanJSONTests
//
//  Created by Pircate on 2018/5/3.
//  Copyright © 2018年 Pircate. All rights reserved.
//

import XCTest

struct ValueNotFound<T: Codable>: Codable {
    let null: T
}

struct KeyNotFound: Codable {
    let keyNotFound: String
}

struct TypeMismatch: Codable {
    let integer: Double
    let double: String
    let boolean: String
    let string: Int
}

struct Nested: Codable {
    let string: String
}

struct Wrapper: Codable {
    let nested: Nested
}

struct Optional: Codable {
    let optional: String?
}

class CleanJSONTests: XCTestCase {
    
    func testValueNotFound() {
        let data = """
                    {
                      "null": null,
                    }
                """.data(using: .utf8)!
        do {
            let stringValue = try JSONDecoder().decode(ValueNotFound<String>.self, from: data)
            let intValue = try JSONDecoder().decode(ValueNotFound<Int>.self, from: data)
            let doubleValue = try JSONDecoder().decode(ValueNotFound<Double>.self, from: data)
            let boolValue = try JSONDecoder().decode(ValueNotFound<Bool>.self, from: data)
            let arrayValue = try JSONDecoder().decode(ValueNotFound<[String]>.self, from: data)
            let objectValue = try JSONDecoder().decode(ValueNotFound<Nested>.self, from: data)
            XCTAssertEqual(stringValue.null, "")
            XCTAssertEqual(intValue.null, 0)
            XCTAssertEqual(doubleValue.null, 0)
            XCTAssertEqual(boolValue.null, false)
            XCTAssertEqual(arrayValue.null, [])
            XCTAssertEqual(objectValue.null.string, "")
        } catch {
            XCTAssertNil(error)
        }
    }
    
    func testKeyNotFound() {
        let data = "{}".data(using: .utf8)!
        do {
            let object = try JSONDecoder().decode(KeyNotFound.self, from: data)
            XCTAssertEqual(object.keyNotFound, "")
        } catch {
            XCTAssertNil(error)
        }
    }
    
    func testTypeMismatch() {
        
        let data = """
                    {
                      "integer": 1,
                      "double": 3.14,
                      "boolean": true,
                      "string": "10"
                    }
                """.data(using: .utf8)!
        
        do {
            let object = try JSONDecoder().decode(TypeMismatch.self, from: data)
            XCTAssertEqual(object.integer, 1.0)
            XCTAssertEqual(object.double, "3.14")
            XCTAssertEqual(object.boolean, "true")
            XCTAssertEqual(object.string, 10)
        } catch {
            XCTAssertNil(error)
        }
    }
    
    func testNested() {
        let data = """
                    {
                      "nested": {
                                  "string": 10
                                }
                    }
                """.data(using: .utf8)!
        do {
            let object = try JSONDecoder().decode(Wrapper.self, from: data)
            XCTAssertEqual(object.nested.string, "10")
        } catch {
            XCTAssertNil(error)
        }
    }
    
    func testOptional() {
        let data = """
                    {
                      "optional": null
                    }
                """.data(using: .utf8)!
        do {
            let object = try JSONDecoder().decode(Optional.self, from: data)
            XCTAssertNil(object.optional)
        } catch {
            XCTAssertNil(error)
        }
    }
}
