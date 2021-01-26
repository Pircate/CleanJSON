// 
//  DecodeOptionalTests.swift
//  CleanJSON_Tests
//
//  Created by Pircate(swifter.dev@gmail.com) on 2019/5/28
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
import CleanJSON

struct Model: Codable {
    let keyNotFound: Nested?
    let valueNotFound: Nested?
    let jsonString: Nested?
    
    struct Nested: Codable {
        let value: String
    }
}

class DecodeOptionalTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    struct CustomAdapter: JSONAdapter {
        func adaptIfPresent(_ decoder: CleanDecoder) throws -> Double? {
            guard let stringValue = try decoder.decodeIfPresent(String.self) else {
                return nil
            }
            
            return Double(stringValue) ?? 0
        }
        
        func adaptIfPresent(_ decoder: CleanDecoder) throws -> Date? {
            guard let stringValue = try decoder.decodeIfPresent(String.self) else {
                return nil
            }
            
            return Date(timeIntervalSince1970: Double(stringValue) ?? 0)
        }
    }

    func testOptional() {
        let data = """
                    {
                      "string": null,
                      "uint": 10,
                      "float": 4.9,
                      "double": "3.14",
                      "date": "1611555423"
                    }
                """.data(using: .utf8)!
        do {
            let decoder = CleanJSONDecoder()
            decoder.valueNotFoundDecodingStrategy = .custom(CustomAdapter())
            let object = try decoder.decode(Optional.self, from: data)
            XCTAssertNil(object.string)
            XCTAssertNil(object.boolean)
            XCTAssertNil(object.int)
            XCTAssertEqual(object.uint, 10)
            XCTAssertEqual(object.float, 4.9)
            XCTAssertEqual(object.double, 3.14)
            XCTAssertEqual(object.date, Date(timeIntervalSince1970: 1611555423))
        } catch {
            XCTAssertNil(error)
        }
        
        do {
            let data = """
                    {
                      "null": null,
                    }
                """.data(using: .utf8)!
            
            let decoder = CleanJSONDecoder()
            
            let stringValue = try decoder.decode(ValueNotFound<String?>.self, from: data)
            let intValue = try decoder.decode(ValueNotFound<Int?>.self, from: data)
            let int8Value = try decoder.decode(ValueNotFound<Int8?>.self, from: data)
            let int16Value = try decoder.decode(ValueNotFound<Int16?>.self, from: data)
            let int32Value = try decoder.decode(ValueNotFound<Int32?>.self, from: data)
            let int64Value = try decoder.decode(ValueNotFound<Int64?>.self, from: data)
            let uintValue = try decoder.decode(ValueNotFound<UInt?>.self, from: data)
            let uint8Value = try decoder.decode(ValueNotFound<UInt8?>.self, from: data)
            let uint16Value = try decoder.decode(ValueNotFound<UInt16?>.self, from: data)
            let uint32Value = try decoder.decode(ValueNotFound<UInt32?>.self, from: data)
            let uint64Value = try decoder.decode(ValueNotFound<UInt64?>.self, from: data)
            let floatValue = try decoder.decode(ValueNotFound<Float?>.self, from: data)
            let doubleValue = try decoder.decode(ValueNotFound<Double?>.self, from: data)
            let boolValue = try decoder.decode(ValueNotFound<Bool?>.self, from: data)
            let arrayValue = try decoder.decode(ValueNotFound<[String]?>.self, from: data)
            let objectValue = try decoder.decode(ValueNotFound<Nested?>.self, from: data)
            let enumValue = try decoder.decode(ValueNotFound<Enum?>.self, from: data)
            let dateValue = try decoder.decode(ValueNotFound<Date?>.self, from: data)
            let urlValue = try decoder.decode(ValueNotFound<URL?>.self, from: data)
            let decimalValue = try decoder.decode(ValueNotFound<Decimal?>.self, from: data)
            let dataValue = try decoder.decode(ValueNotFound<Data?>.self, from: data)
            let dictValue = try decoder.decode(ValueNotFound<[String: String]?>.self, from: data)
            
            XCTAssertEqual(stringValue.null, nil)
            XCTAssertEqual(intValue.null, nil)
            XCTAssertEqual(int8Value.null, nil)
            XCTAssertEqual(int16Value.null, nil)
            XCTAssertEqual(int32Value.null, nil)
            XCTAssertEqual(int64Value.null, nil)
            XCTAssertEqual(uintValue.null, nil)
            XCTAssertEqual(uint8Value.null, nil)
            XCTAssertEqual(uint16Value.null, nil)
            XCTAssertEqual(uint32Value.null, nil)
            XCTAssertEqual(uint64Value.null, nil)
            XCTAssertEqual(floatValue.null, nil)
            XCTAssertEqual(doubleValue.null, nil)
            XCTAssertEqual(boolValue.null, nil)
            XCTAssertEqual(arrayValue.null, nil)
            XCTAssertEqual(objectValue.null?.string, nil)
            XCTAssertEqual(enumValue.null, nil)
            XCTAssertEqual(dateValue.null, nil)
            XCTAssertEqual(urlValue.null, nil)
            XCTAssertEqual(decimalValue.null, nil)
            XCTAssertEqual(dataValue.null, nil)
            XCTAssertEqual(dictValue.null, nil)
        } catch {
            XCTAssertNil(error)
        }
    }
    
    func testNestedOptional() {
        let data = #"""
                    {
                      "valueNotFound": null,
                      "jsonString": "{\"value\":\"jsonString\"}"
                    }
                """#.data(using: .utf8)!
        do {
            let decoder = CleanJSONDecoder()
            decoder.jsonStringDecodingStrategy = .all
            let model = try decoder.decode(Model.self, from: data)
            XCTAssertEqual(model.keyNotFound?.value, nil)
            XCTAssertEqual(model.valueNotFound?.value, nil)
            XCTAssertEqual(model.jsonString?.value, "jsonString")
        } catch {
            XCTAssertNil(error)
        }
    }
}
