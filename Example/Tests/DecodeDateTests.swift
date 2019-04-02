// 
//  DecodeDateTests.swift
//  CleanJSON_Tests
//
//  Created by Pircate(swifter.dev@gmail.com) on 2019/4/2
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
import CleanJSON

struct DateModel: Codable {
    let date: Date
}

class DecodeDateTests: XCTestCase {

    func testDecodeDate() {
        let data = """
                {
                  "date": 1000000
                }
                """.data(using: .utf8)!
        do {
            let model = try CleanJSONDecoder().decode(DateModel.self, from: data)
            XCTAssertEqual(model.date, Date(timeIntervalSinceReferenceDate: 1000000))
        } catch {
            XCTAssertNil(error)
        }
    }
    
    func testDecodeDateSecondsSince1970() {
        let data = """
                {
                  "date": 1000000
                }
                """.data(using: .utf8)!
        do {
            let decoder = CleanJSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            let model = try decoder.decode(DateModel.self, from: data)
            XCTAssertEqual(model.date, Date(timeIntervalSince1970: 1000000))
        } catch {
            XCTAssertNil(error)
        }
    }
    
    func testDecodeDateMillisecondsSince1970() {
        let data = """
                {
                  "date": 1000000
                }
                """.data(using: .utf8)!
        do {
            let decoder = CleanJSONDecoder()
            decoder.dateDecodingStrategy = .millisecondsSince1970
            let model = try decoder.decode(DateModel.self, from: data)
            XCTAssertEqual(model.date, Date(timeIntervalSince1970: 1000000.0 / 1000.0))
        } catch {
            XCTAssertNil(error)
        }
    }
    
    func testDecodeDateCustom() {
        let data = """
                {
                  "date": 1000000
                }
                """.data(using: .utf8)!
        do {
            let decoder = CleanJSONDecoder()
            let date = Date()
            decoder.dateDecodingStrategy = .custom { _ -> Date in
                return date
            }
            let model = try decoder.decode(DateModel.self, from: data)
            XCTAssertEqual(model.date, date)
        } catch {
            XCTAssertNil(error)
        }
    }
}
