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
    
    // 可选的 URL 类型解析失败的时候返回一个默认 url
    func adaptIfPresent(_ decoder: CleanDecoder) throws -> URL? {
        return URL(string: "https://google.com")
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
                 "url": null,
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
            debugPrint("boolean:", model.boolean)
            debugPrint("integer:", model.integer)
            debugPrint("double:", model.double)
            debugPrint("string:", model.string)
            debugPrint("array:", model.array)
            debugPrint("nested.a:", model.nested.a)
            debugPrint("nested.b:", model.nested.b)
            debugPrint("nested.c:", model.nested.c)
            debugPrint("keyNotFound:", model.keyNotFound)
            debugPrint("snakeCase:", model.snakeCase)
            debugPrint("optional:", model.optional)
            debugPrint("date:", model.date)
            debugPrint("url:", model.url)
            debugPrint("decimal:", model.decimal)
            debugPrint("data:", model.data)
            debugPrint("dict:", model.dict)
        } catch {
            debugPrint(error)
        }
    }
}
