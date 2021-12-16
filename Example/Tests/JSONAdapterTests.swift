// 
//  JSONAdapterTests.swift
//  CleanJSON_Tests
//
//  Created by Pircate(swifter.dev@gmail.com) on 2019/3/22
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
import CleanJSON

struct CustomAdapter: JSONAdapter {
    
    func adapt(_ value: JSONValue) -> Bool {
        value == .null
    }
    
    func adapt<T>(_ value: JSONValue) -> T where T : FixedWidthInteger {
        switch value {
        case .string(let string):
            let formatter = NumberFormatter()
            formatter.generatesDecimalNumbers = true
            formatter.numberStyle = .decimal
            return T(formatter.number(from: string)?.intValue ?? 0)
        default:
            return 0
        }
    }
    
    func adapt<T>(_ value: JSONValue) -> T where T : BinaryFloatingPoint, T : LosslessStringConvertible {
        switch value {
        case .string(let string):
            return T(Double(string)?.advanced(by: 1) ?? 0)
        default:
            return 0
        }
    }
    
    func adapt(_ value: JSONValue) -> String {
        switch value {
        case .string(let string):
            return string
        case .number(let string):
            if let intValue = Int(string) {
                return "$" + "\(intValue)"
            } else if let doubleValue = Double(string) {
                return String(format: "%.f", doubleValue)
            }
            return ""
        case .bool(let bool):
            return String(bool).uppercased()
        default:
            return ""
        }
    }
}

class JSONAdapterTests: XCTestCase {

    func testJSONAdapter() {
        let data = """
                    {
                      "null": null,
                      "stringToInt": "1,314",
                      "stringToDouble": "3.141592654",
                      "boolToString": true,
                      "doubleToString": 3.14,
                      "intToString": 10
                    }
                """.data(using: .utf8)!
        
        do {
            let decoder = CleanJSONDecoder()
            decoder.keyNotFoundDecodingStrategy = .useDefaultValue
            decoder.valueNotFoundDecodingStrategy = .custom(CustomAdapter())
            let object = try decoder.decode(TypeMismatch.self, from: data)
            XCTAssertEqual(object.null, true)
            XCTAssertEqual(object.stringToInt, 1314)
            XCTAssertEqual(object.stringToDouble, 4.141592654)
            XCTAssertNil(object.boolToString)
            XCTAssertEqual(object.intToString, "$10")
            XCTAssertEqual(object.doubleToString, "3")
        } catch {
            XCTAssertNil(error)
        }
    }
}
