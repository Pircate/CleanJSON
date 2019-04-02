// 
//  DecodeDecimalTests.swift
//  CleanJSON_Tests
//
//  Created by Pircate(swifter.dev@gmail.com) on 2019/4/2
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
import CleanJSON

class DecodeDecimalTests: XCTestCase {
    
    struct DecimalModel: Codable {
        let decimal: Decimal
    }
    
    struct Adapter: JSONAdapter {
        func adapt(_ decoder: CleanDecoder) throws -> Decimal {
            return Decimal(9999)
        }
    }

    func testDecodeDecimal() {
        let data = """
                {
                  "decimal": null
                }
                """.data(using: .utf8)!
        do {
            let decoder = CleanJSONDecoder()
            decoder.valueNotFoundDecodingStrategy = .custom(Adapter())
            
            let model = try decoder.decode(DecimalModel.self, from: data)
            XCTAssertEqual(model.decimal, Decimal(9999))
        } catch {
            XCTAssertNil(error)
        }
    }
}
