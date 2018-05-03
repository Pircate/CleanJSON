//
//  ViewController.swift
//  CleanJSON
//
//  Created by GorXion on 2018/5/3.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import UIKit

struct TestModel: Codable {
    let boolean: String
    let integer: Float
    let double: Int
    let string: Int
    let array: [Int]
    let nested: Nested
    
    struct Nested: Codable {
        let a: String
        let b: Double
        let c: Int
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let json = """
             {
                 "boolean": true,
                 "integer": 1,
                 "double": -3.14159265358979323846,
                 "string": "string",
                 "array": [1, 2, 3],
                 "nested": {
                     "a": "alpha",
                     "b": "bravo",
                     "c": "charlie"
                 }
             }
        """.data(using: .utf8)!
        
        let model = try! JSONDecoder().decode(TestModel.self, from: json)
        
        debugPrint(model.boolean)
        debugPrint(model.integer)
        debugPrint(model.double)
        debugPrint(model.string)
        debugPrint(model.array)
        debugPrint(model.nested.a)
        debugPrint(model.nested.b)
        debugPrint(model.nested.c)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

