// 
//  NestedContainerTests.swift
//  CleanJSON_Tests
//
//  Created by Pircate(gao497868860@gmail.com) on 2019/2/26
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
import CleanJSON

struct Container: Codable {
    let nested: Nested
    
    struct Nested: Codable {
        let string: String
    }
    
    enum NestedCodingKeys: CodingKey {
        case string
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let nestedContainer = try container.nestedContainer(
            keyedBy: NestedCodingKeys.self,
            forKey: .nested)
        
        let string = try nestedContainer.decode(String.self, forKey: .string)
        self.nested = Nested(string: string)
    }
}

class NestedContainerTests: XCTestCase {

    func testKeyNotFound() {
        let data = """
                    {}
                """.data(using: .utf8)!
        let model = try! CleanJSONDecoder().decode(Container.self, from: data)
        XCTAssertEqual(model.nested.string, "")
    }
    
    func testValueNotFound() {
        let data = """
                    {
                      "nested": null
                    }
                """.data(using: .utf8)!
        let model = try! CleanJSONDecoder().decode(Container.self, from: data)
        XCTAssertEqual(model.nested.string, "")
    }
    
    func testNestedContainer() {
        let data = """
                    {
                      "nested": {"string": "nested"}
                    }
                """.data(using: .utf8)!
        let model = try! CleanJSONDecoder().decode(Container.self, from: data)
        XCTAssertEqual(model.nested.string, "nested")
    }
}
