// 
//  JSONContainerTests.swift
//  CleanJSON_Tests
//
//  Created by Pircate(swifter.dev@gmail.com) on 2020/8/27
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
import CleanJSON

struct TestModel<T: Codable>: Codable {
    let boolean: Int
    let integer: Float
    let double: String
    let string: Double
    let array: [String]
    let nested: Nested
    let keyNotFound: T
    let snakeCase: String
    let optional: String?
    let date: Date
    let decimal: Decimal
    let data: Data
    let url: URL?
    let dict: [String: T]
    
    struct Nested: Codable {
        let a: String
        let b: Bool
        let c: Int
    }
    
    struct NotPresent: Codable {
        let a: String
    }
}

enum ConnectionState: Int, Codable, CaseDefaultable {
    case connected
    case connecting
    case disconnect
    
    static var defaultCase: ConnectionState {
        return .disconnect
    }
}

struct TestAdapter: JSONAdapter {
    
    // 由于 Swift 布尔类型不是非 0 即 true，所以默认没有提供类型转换。
    // 如果想实现 Int 转 Bool 可以自定义解码。
    func adapt(_ decoder: CleanDecoder) throws -> Bool {
        guard let intValue = try decoder.decodeIfPresent(Int.self) else { return false }
        
        return intValue != 0
    }
    
    // 日期为 null 或者类型不匹配时使用当前时间
    func adapt(_ decoder: CleanDecoder) throws -> Date {
        return Date()
    }
    
    // 可选的 URL 类型解析失败的时候返回一个默认 url
    func adaptIfPresent(_ decoder: CleanDecoder) throws -> URL? {
        return URL(string: "https://google.com")
    }
}

class JSONContainerTests: XCTestCase {

    func testExample() throws {
        do {
            let decoder = CleanJSONDecoder()
            decoder.keyDecodingStrategy = .mapper([
                ["snake_case"]: "snakeCase",
                ["nested", "alpha"]: "a"
            ])
            decoder.dateDecodingStrategy = .secondsSince1970
            
            // 值为 null 或类型不匹配时解码策略
            decoder.valueNotFoundDecodingStrategy = .custom(TestAdapter())
            
            // JSON 字符串转对象解码策略
            decoder.jsonStringDecodingStrategy = .all
            
            let model = try decoder.decode(TestModel<ConnectionState>.self, from: [
                "boolean": true,
                "integer": 1,
                "double": -3.14159265358979323846,
                "string": "string",
                "array": [1, 2.1, "3", true],
                "snake_case": "convertFromSnakeCase",
                "date": "date",
                "nested": "{\"alpha\": \"alpha\", \"b\": 1, \"c\": 2}",
                "data": "",
                "url": NSNull(),
                "dict": ["hello": 2]
            ])
            XCTAssertEqual(model.boolean, 0)
            XCTAssertEqual(model.integer, 1.0)
            XCTAssertEqual(model.double, "-3.141592653589793")
            XCTAssertEqual(model.string, 0.0)
            XCTAssertEqual(model.array, ["1", "2.1", "3", "true"])
            XCTAssertEqual(model.nested.a, "alpha")
            XCTAssertEqual(model.nested.b, true)
            XCTAssertEqual(model.nested.c, 2)
            XCTAssertEqual(model.keyNotFound, .disconnect)
            XCTAssertEqual(model.snakeCase, "convertFromSnakeCase")
            XCTAssertNil(model.optional)
            XCTAssertEqual(model.url, URL(string: "https://google.com"))
            XCTAssertEqual(model.decimal, 0)
            XCTAssertEqual(model.data, Data())
            XCTAssertEqual(model.dict, ["hello": .disconnect])
        } catch {
            debugPrint(error)
        }
    }
}
