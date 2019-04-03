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
    
    func adapt(_ decoder: CleanDecoder) throws -> Bool {
        return decoder.decodeNull()
    }
    
    func adapt(_ decoder: CleanDecoder) throws -> Int {
        if let stringValue = try decoder.decodeIfPresent(String.self) {
            let formatter = NumberFormatter()
            formatter.generatesDecimalNumbers = true
            formatter.numberStyle = .decimal
            return formatter.number(from: stringValue)?.intValue ?? 0
        }
        return 0
    }
    
    func adapt(_ decoder: CleanDecoder) throws -> Double {
        if let stringValue = try decoder.decodeIfPresent(String.self) {
            return Double(stringValue)?.advanced(by: 1) ?? 0
        }
        return 0
    }
    
    func adapt(_ decoder: CleanDecoder) throws -> String {
        if let intValue = try decoder.decodeIfPresent(Int.self) {
            return "$" + String(intValue)
        } else if let doubleValue = try decoder.decodeIfPresent(Double.self) {
            return String(format: "%.f", doubleValue)
        } else if let boolValue = try decoder.decodeIfPresent(Bool.self) {
            return String(boolValue).uppercased()
        }
        return ""
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
