# CleanJSON

在类型不一致或者键值不存在的时候不会解析失败，部分类型增加了类型转换。
```diff 

- 注意: 只支持JSON数据类型的默认值
- Number, Boolean, String, Object, Array
- 对应swift的Int, UInt, Float, Double, Bool, String, T: Codable, Array<E: Codable>

```

## Installation

将CleanJSON.swift文件放到项目工程模块即可

## Demo

``` swift

struct TestModel<T: Codable>: Codable {
    let boolean: Int
    let integer: Float
    let double: String
    let string: Double
    let array: [String]
    let nested: Nested
    let notPresent: T
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
        
if let model = try? JSONDecoder().decode(TestModel<String>.self, from: json) {
    debugPrint(model.boolean)      // 0
    debugPrint(model.integer)      // 1.0
    debugPrint(model.double)       // "-3.14159265358979"
    debugPrint(model.string)       // 0.0
    debugPrint(model.array)        // []
    debugPrint(model.nested.a)     // "alpha"
    debugPrint(model.nested.b)     // false
    debugPrint(model.nested.c)     // 0
    debugPrint(model.notPresent)   // ""
    debugPrint(model.optional)     // nil
}

```
