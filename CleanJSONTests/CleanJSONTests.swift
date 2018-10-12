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
    let string: String
    let boolean: Bool
    let int: Int
    let uint: UInt
    let float: Float
    let double: Double
    let array: [String]
    let object: Nested
}

struct TypeMismatch: Codable {
    let integer: Double
    let double: String
    let boolean: Float
    let string: Int
    
    let stringToUInt: UInt
    let stringToInt: Int
    let stringToFloat: Float
    let stringToDouble: Double
    let stringToBool: Bool
    
    let boolToString: String?
}

struct Nested: Codable {
    let string: String
}

struct Wrapper: Codable {
    let nested: Nested
}

struct Optional: Codable {
    let string: String?
    let boolean: Bool?
    let int: Int?
    let uint: UInt?
    let float: Float?
    let double: Double?
}

class CleanJSONTests: XCTestCase {
    
    func testValueNotFound() {
        let data = """
                    {
                      "null": null,
                    }
                """.data(using: .utf8)!
        do {
            let decoder = CleanJSONDecoder()
            let stringValue = try decoder.decode(ValueNotFound<String>.self, from: data)
            let intValue = try decoder.decode(ValueNotFound<Int>.self, from: data)
            let uintValue = try decoder.decode(ValueNotFound<UInt>.self, from: data)
            let floatValue = try decoder.decode(ValueNotFound<Float>.self, from: data)
            let doubleValue = try decoder.decode(ValueNotFound<Double>.self, from: data)
            let boolValue = try decoder.decode(ValueNotFound<Bool>.self, from: data)
            let arrayValue = try decoder.decode(ValueNotFound<[String]>.self, from: data)
            let objectValue = try decoder.decode(ValueNotFound<Nested>.self, from: data)
            XCTAssertEqual(stringValue.null, "")
            XCTAssertEqual(intValue.null, 0)
            XCTAssertEqual(uintValue.null, 0)
            XCTAssertEqual(floatValue.null, 0)
            XCTAssertEqual(doubleValue.null, 0)
            XCTAssertEqual(boolValue.null, false)
            XCTAssertEqual(arrayValue.null, [])
            XCTAssertEqual(objectValue.null.string, "")
        } catch {
            XCTAssertNil(error)
        }
        
        do {
            _ = try CleanJSONDecoder().decode(ValueNotFound<Date>.self, from: data)
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func testKeyNotFound() {
        let data = "{}".data(using: .utf8)!
        do {
            let object = try CleanJSONDecoder().decode(KeyNotFound.self, from: data)
            XCTAssertEqual(object.string, "")
            XCTAssertEqual(object.boolean, false)
            XCTAssertEqual(object.int, 0)
            XCTAssertEqual(object.uint, 0)
            XCTAssertEqual(object.float, 0)
            XCTAssertEqual(object.double, 0)
            XCTAssertEqual(object.array, [])
            XCTAssertEqual(object.object.string, "")
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
                      "string": "10",
                      "stringToUInt": "520",
                      "stringToInt": "1314",
                      "stringToFloat": "1.414",
                      "stringToDouble": "3.141592654",
                      "stringToBool": "false",
                      "boolToString": true
                    }
                """.data(using: .utf8)!
        
        do {
            let object = try CleanJSONDecoder().decode(TypeMismatch.self, from: data)
            XCTAssertEqual(object.integer, 1.0)
            XCTAssertEqual(object.double, "3.14")
            XCTAssertEqual(object.boolean, 0)
            XCTAssertEqual(object.string, 10)
            XCTAssertEqual(object.stringToUInt, 520)
            XCTAssertEqual(object.stringToInt, 1314)
            XCTAssertEqual(object.stringToFloat, 1.414)
            XCTAssertEqual(object.stringToDouble, 3.141592654)
            XCTAssertEqual(object.stringToBool, false)
            XCTAssertEqual(object.boolToString, "true")
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
            let object = try CleanJSONDecoder().decode(Wrapper.self, from: data)
            XCTAssertEqual(object.nested.string, "10")
        } catch {
            XCTAssertNil(error)
        }
    }
    
    func testOptional() {
        let data = """
                    {
                      "string": null,
                      "uint": 10,
                      "float": 4.9
                    }
                """.data(using: .utf8)!
        do {
            let object = try CleanJSONDecoder().decode(Optional.self, from: data)
            XCTAssertNil(object.string)
            XCTAssertNil(object.boolean)
            XCTAssertNil(object.int)
            XCTAssertEqual(object.uint, 10)
            XCTAssertEqual(object.float, 4.9)
            XCTAssertNil(object.double)
        } catch {
            XCTAssertNil(error)
        }
    }
}
