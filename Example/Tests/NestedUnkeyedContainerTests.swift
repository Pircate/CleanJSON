// 
//  NestedUnkeyedContainerTests.swift
//  CleanJSON_Tests
//
//  Created by Pircate(swifter.dev@gmail.com) on 2019/2/26
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
import CleanJSON

struct UnkeyedContainer: Codable {
    let nestedUnkeyed: [Container]
    
    struct Container: Codable {
        let nested: Nested
        
        struct Nested: Codable {
            let string: String
        }
        
        enum NestedCodingKeys: CodingKey {
            case string
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var nestedUnkeyedContainer = try container.nestedUnkeyedContainer(forKey: .nestedUnkeyed)
        
        guard let count = nestedUnkeyedContainer.count, count > 0 else {
            self.nestedUnkeyed = []
            return
        }
        
        self.nestedUnkeyed = try (0...count - 1).map { _ in
            let nestedContainer = try nestedUnkeyedContainer.nestedContainer(keyedBy: Container.NestedCodingKeys.self)
            let string = try nestedContainer.decode(String.self, forKey: .string)
            return Container(nested: Container.Nested(string: string))
        }
    }
}

class NestedUnkeyedContainerTests: XCTestCase {

    func testKeyNotFound() {
        let data = """
                    {}
                """.data(using: .utf8)!
        do {
            let model = try CleanJSONDecoder().decode(UnkeyedContainer.self, from: data)
            XCTAssertEqual(model.nestedUnkeyed.count, 0)
        } catch {
            XCTAssertNil(error)
        }
    }
    
    func testValueNotFound() {
        let data = """
                    {
                        "nestedUnkeyed": null
                    }
                """.data(using: .utf8)!
        do {
            let model = try CleanJSONDecoder().decode(UnkeyedContainer.self, from: data)
            XCTAssertEqual(model.nestedUnkeyed.count, 0)
        } catch {
            XCTAssertNil(error)
        }
    }
    
    func testNestedUnkeyedContainer() {
        let data = """
                    {
                        "nestedUnkeyed": ["1", "2", "3"]
                    }
                """.data(using: .utf8)!
        do {
            let model = try CleanJSONDecoder().decode(UnkeyedContainer.self, from: data)
            XCTAssertEqual(model.nestedUnkeyed.count, 3)
        } catch {
            XCTAssertNil(error)
        }
    }
    
    func testUnkeyedValueNotFound() {
        let data = """
                    {
                        "nestedUnkeyed": [null]
                    }
                """.data(using: .utf8)!
        do {
            let model = try CleanJSONDecoder().decode(UnkeyedContainer.self, from: data)
            XCTAssertEqual(model.nestedUnkeyed.count, 1)
        } catch {
            XCTAssertNil(error)
        }
    }
}
