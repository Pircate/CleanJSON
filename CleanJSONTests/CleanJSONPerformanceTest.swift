//
//  CleanJSONPerformanceTest.swift
//  CleanJSONPerformanceTest
//
//  Created by Pircate on 2018/8/31.
//  Copyright © 2018年 Pircate. All rights reserved.
//

import XCTest

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

class CleanJSONPerformanceTest: XCTestCase {
    
    func testPerformance() {
        measure {
            do {
                let objects = try JSONDecoder().decode([Performance<String>].self, from: data)
                XCTAssertEqual(objects.count, count)
            } catch {}
        }
    }
}
