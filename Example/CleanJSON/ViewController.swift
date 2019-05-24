//
//  ViewController.swift
//  CleanJSON
//
//  Created by Pircate on 10/12/2018.
//  Copyright (c) 2018 Pircate. All rights reserved.
//

import UIKit
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

enum Enum: Int, Codable, CaseDefaultable {
    case case1
    case case2
    case case3
    
    static var defaultCase: Enum {
        return .case2
    }
}

struct CustomAdapter: JSONAdapter {
    
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
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let json = #"""
             {
                 "boolean": true,
                 "integer": 1,
                 "double": -3.14159265358979323846,
                 "string": "string",
                 "array": [1, 2.1, "3", true],
                 "snake_case": "convertFromSnakeCase",
                 "date": "date",
                 "nested": "{\"a\": \"alpha\", \"b\": 1, \"c\": 2}",
                 "data": "",
                 "dict": {"hello": 2}
             }
        """#.data(using: .utf8)!
        
        do {
            let decoder = CleanJSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .secondsSince1970
            
            // 值为 null 或类型不匹配时解码策略
            decoder.valueNotFoundDecodingStrategy = .custom(CustomAdapter())
            
            // JSON 字符串转对象解码策略
            decoder.jsonStringDecodingStrategy = .all
            
            let model = try decoder.decode(TestModel<Enum>.self, from: json)
            debugPrint(model.boolean)
            debugPrint(model.integer)
            debugPrint(model.double)
            debugPrint(model.string)
            debugPrint(model.array)
            debugPrint(model.nested.a)
            debugPrint(model.nested.b)
            debugPrint(model.nested.c)
            debugPrint(model.keyNotFound)
            debugPrint(model.snakeCase)
            debugPrint(model.optional ?? "nil")
            debugPrint(model.date)
            debugPrint(model.decimal)
            debugPrint(model.data)
            debugPrint(model.dict)
        } catch {
            debugPrint(error)
        }
    }
}
