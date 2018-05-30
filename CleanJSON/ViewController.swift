//
//  ViewController.swift
//  CleanJSON
//
//  Created by GorXion on 2018/5/3.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import UIKit

struct TestModel: Codable {
    let boolean: Int
    let integer: Float
    let double: String
    let string: Double
    let array: [String]
    let nested: Nested
    let notPresent: NotPresent
    let optional: String?
    
    struct Nested: Codable {
        let a: String
        let b: Bool
        let c: Int
    }
    
    struct NotPresent: Codable {
        let a: String
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
                 "array": [1, 2.1, "3", true],
                 "nested": {
                     "a": "alpha",
                     "b": "bravo",
                     "c": "charlie"
                 }
             }
        """.data(using: .utf8)!
        
        if let model = try? JSONDecoder().decode(TestModel.self, from: json) {
            debugPrint(model.boolean)
            debugPrint(model.integer)
            debugPrint(model.double)
            debugPrint(model.string)
            debugPrint(model.array)
            debugPrint(model.nested.a)
            debugPrint(model.nested.b)
            debugPrint(model.nested.c)
            debugPrint(model.notPresent.a)
            debugPrint(model.optional)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

