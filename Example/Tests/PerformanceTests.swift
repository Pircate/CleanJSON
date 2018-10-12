// 
//  PerformanceTests.swift
//  CleanJSON_Tests
//
//  Created by Pircate(gao497868860@gmail.com) on 2018/10/12
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
import CleanJSON

public struct Performance<T: Codable>: Codable {
    let name: String
    let iata: String
    let icao: String
    let coordinates: [Double]
    
    public struct Runway: Codable {
        let direction: String
        let distance: Int
        let surface: T
    }
    
    let runways: [Runway]
}

func airportsJSON(count: Int) -> Data {
    let bundle = Bundle(for: CleanJSONTests.self)
    let resource = "airports\(count)"
    guard let url = bundle.url(forResource: resource, withExtension: "json"),
        let data = try? Data(contentsOf: url) else {
            fatalError()
    }
    
    return data
}

let count = 1000 // 1, 10, 100, 1000, or 10000
let data = airportsJSON(count: count)

class PerformanceTests: XCTestCase {

    func testExample() {
        measure {
            do {
                let objects = try CleanJSONDecoder().decode([Performance<String>].self, from: data)
                XCTAssertEqual(objects.count, count)
            } catch {}
        }
    }
}
