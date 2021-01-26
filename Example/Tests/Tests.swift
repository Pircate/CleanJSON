import XCTest
import CleanJSON

struct ValueNotFound<T: Codable>: Codable {
    let null: T
}

struct KeyNotFound<T: Codable>: Codable {
    let string: String
    let boolean: Bool
    let int: Int
    let int8: Int8
    let int16: Int16
    let int32: Int32
    let int64: Int64
    let uint: UInt
    let uint8: UInt8
    let uint16: UInt16
    let uint32: UInt32
    let uint64: UInt64
    let float: Float
    let double: Double
    let array: [String]
    let date: Date
    let decimal: Decimal
    let data: Data
    let object: Nested
    let `enum`: Enum
    let any: T
    let dict: [String: T]
}

struct TypeMismatch: Codable {
    
    let null: Bool
    
    let stringToUInt: UInt
    let stringToInt: Int
    let stringToFloat: Float
    let stringToDouble: Double
    let stringToBool: Bool
    
    let boolToString: String?
    let intToString: String
    let doubleToString: String
}

struct Nested: Codable {
    let string: String
}

struct Wrapper: Codable {
    let nested: Nested
}

struct Optional: Codable {
    let string: String?
    let boolean: Bool?
    let int: Int?
    let uint: UInt?
    let float: Float?
    let double: Double?
    let date: Date?
}

struct EnumStruct: Codable {
    let `enum`: Enum
    let enum1: Enum
    let enum2: Enum
    let enum3: Enum?
}

enum Enum: Int, CaseDefaultable, Codable {
    case case1
    case case2
    case case3
    
    static var defaultCase: Enum {
        return .case2
    }
}

class CleanJSONTests: XCTestCase {
    
    func testValueNotFound() {
        let data = """
                    {
                      "null": null,
                    }
                """.data(using: .utf8)!
        do {
            let decoder = CleanJSONDecoder()
            let stringValue = try decoder.decode(ValueNotFound<String>.self, from: data)
            let intValue = try decoder.decode(ValueNotFound<Int>.self, from: data)
            let int8Value = try decoder.decode(ValueNotFound<Int8>.self, from: data)
            let int16Value = try decoder.decode(ValueNotFound<Int16>.self, from: data)
            let int32Value = try decoder.decode(ValueNotFound<Int32>.self, from: data)
            let int64Value = try decoder.decode(ValueNotFound<Int64>.self, from: data)
            let uintValue = try decoder.decode(ValueNotFound<UInt>.self, from: data)
            let uint8Value = try decoder.decode(ValueNotFound<UInt8>.self, from: data)
            let uint16Value = try decoder.decode(ValueNotFound<UInt16>.self, from: data)
            let uint32Value = try decoder.decode(ValueNotFound<UInt32>.self, from: data)
            let uint64Value = try decoder.decode(ValueNotFound<UInt64>.self, from: data)
            let floatValue = try decoder.decode(ValueNotFound<Float>.self, from: data)
            let doubleValue = try decoder.decode(ValueNotFound<Double>.self, from: data)
            let boolValue = try decoder.decode(ValueNotFound<Bool>.self, from: data)
            let arrayValue = try decoder.decode(ValueNotFound<[String]>.self, from: data)
            let objectValue = try decoder.decode(ValueNotFound<Nested>.self, from: data)
            let enumValue = try decoder.decode(ValueNotFound<Enum>.self, from: data)
            let dateValue = try decoder.decode(ValueNotFound<Date>.self, from: data)
            let decimalValue = try decoder.decode(ValueNotFound<Decimal>.self, from: data)
            let dataValue = try decoder.decode(ValueNotFound<Data>.self, from: data)
            let dictValue = try decoder.decode(ValueNotFound<[String: String]>.self, from: data)
            
            XCTAssertEqual(stringValue.null, "")
            XCTAssertEqual(intValue.null, 0)
            XCTAssertEqual(int8Value.null, 0)
            XCTAssertEqual(int16Value.null, 0)
            XCTAssertEqual(int32Value.null, 0)
            XCTAssertEqual(int64Value.null, 0)
            XCTAssertEqual(uintValue.null, 0)
            XCTAssertEqual(uint8Value.null, 0)
            XCTAssertEqual(uint16Value.null, 0)
            XCTAssertEqual(uint32Value.null, 0)
            XCTAssertEqual(uint64Value.null, 0)
            XCTAssertEqual(floatValue.null, 0)
            XCTAssertEqual(doubleValue.null, 0)
            XCTAssertEqual(boolValue.null, false)
            XCTAssertEqual(arrayValue.null, [])
            XCTAssertEqual(objectValue.null.string, "")
            XCTAssertEqual(enumValue.null, .case2)
            XCTAssertEqual(dateValue.null, Date(timeIntervalSinceReferenceDate: 0))
            XCTAssertEqual(decimalValue.null, Decimal(0))
            XCTAssertEqual(dataValue.null, Data())
            XCTAssertEqual(dictValue.null, [:])
        } catch {
            XCTAssertNil(error)
        }
        
        do {
            _ = try CleanJSONDecoder().decode(ValueNotFound<Date>.self, from: data)
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func testKeyNotFound() {
        let data = "{}".data(using: .utf8)!
        do {
            let object = try CleanJSONDecoder().decode(KeyNotFound<String>.self, from: data)
            XCTAssertEqual(object.string, "")
            XCTAssertEqual(object.boolean, false)
            XCTAssertEqual(object.int, 0)
            XCTAssertEqual(object.int8, 0)
            XCTAssertEqual(object.int16, 0)
            XCTAssertEqual(object.int32, 0)
            XCTAssertEqual(object.int64, 0)
            XCTAssertEqual(object.uint, 0)
            XCTAssertEqual(object.uint8, 0)
            XCTAssertEqual(object.uint16, 0)
            XCTAssertEqual(object.uint32, 0)
            XCTAssertEqual(object.uint64, 0)
            XCTAssertEqual(object.float, 0)
            XCTAssertEqual(object.double, 0)
            XCTAssertEqual(object.array, [])
            XCTAssertEqual(object.date, Date(timeIntervalSinceReferenceDate: 0))
            XCTAssertEqual(object.decimal, Decimal(0))
            XCTAssertEqual(object.data, Data())
            XCTAssertEqual(object.object.string, "")
            XCTAssertEqual(object.enum, Enum.defaultCase)
            XCTAssertEqual(object.any, "")
            XCTAssertEqual(object.dict, [:])
            
            XCTAssertEqual(try CleanJSONDecoder().decode(KeyNotFound<Bool>.self, from: data).any, false)
            XCTAssertEqual(try CleanJSONDecoder().decode(KeyNotFound<Int>.self, from: data).any, 0)
            XCTAssertEqual(try CleanJSONDecoder().decode(KeyNotFound<Int8>.self, from: data).any, 0)
            XCTAssertEqual(try CleanJSONDecoder().decode(KeyNotFound<Int16>.self, from: data).any, 0)
            XCTAssertEqual(try CleanJSONDecoder().decode(KeyNotFound<Int32>.self, from: data).any, 0)
            XCTAssertEqual(try CleanJSONDecoder().decode(KeyNotFound<Int64>.self, from: data).any, 0)
            XCTAssertEqual(try CleanJSONDecoder().decode(KeyNotFound<UInt>.self, from: data).any, 0)
            XCTAssertEqual(try CleanJSONDecoder().decode(KeyNotFound<UInt8>.self, from: data).any, 0)
            XCTAssertEqual(try CleanJSONDecoder().decode(KeyNotFound<UInt16>.self, from: data).any, 0)
            XCTAssertEqual(try CleanJSONDecoder().decode(KeyNotFound<UInt32>.self, from: data).any, 0)
            XCTAssertEqual(try CleanJSONDecoder().decode(KeyNotFound<UInt64>.self, from: data).any, 0)
            XCTAssertEqual(try CleanJSONDecoder().decode(KeyNotFound<Double>.self, from: data).any, 0)
            XCTAssertEqual(try CleanJSONDecoder().decode(KeyNotFound<[String]>.self, from: data).any, [])
            XCTAssertEqual(try CleanJSONDecoder().decode(KeyNotFound<Enum>.self, from: data).any, Enum.defaultCase)
            XCTAssertEqual(try CleanJSONDecoder().decode(KeyNotFound<Date>.self, from: data).any, Date(timeIntervalSinceReferenceDate: 0))
            XCTAssertEqual(try CleanJSONDecoder().decode(KeyNotFound<Decimal>.self, from: data).any, Decimal(0))
        } catch {
            XCTAssertNil(error)
        }
    }
    
    func testTypeMismatch() {
        
        let data = """
                    {
                      "stringToUInt": "520",
                      "stringToInt": "1314",
                      "stringToFloat": "1.414",
                      "stringToDouble": "3.141592654",
                      "boolToString": true,
                      "doubleToString": 3.14,
                      "intToString": 10
                    }
                """.data(using: .utf8)!
        
        do {
            let object = try CleanJSONDecoder().decode(TypeMismatch.self, from: data)
            XCTAssertEqual(object.stringToUInt, 520)
            XCTAssertEqual(object.stringToInt, 1314)
            XCTAssertEqual(object.stringToFloat, 1.414)
            XCTAssertEqual(object.stringToDouble, 3.141592654)
            XCTAssertNil(object.boolToString)
            XCTAssertEqual(object.intToString, "10")
            XCTAssertEqual(object.doubleToString, "3.14")
        } catch {
            XCTAssertNil(error)
        }
    }
    
    func testNested() {
        let data = """
                    {
                      "nested": {
                                  "string": 10
                                }
                    }
                """.data(using: .utf8)!
        do {
            let object = try CleanJSONDecoder().decode(Wrapper.self, from: data)
            XCTAssertEqual(object.nested.string, "10")
        } catch {
            XCTAssertNil(error)
        }
    }
    
    func testDecodeEnum() {
        let data = """
                    {
                      "enum": 3,
                      "enum1": false,
                      "enum2": 0,
                      "enum3": 2.0
                    }
                """.data(using: .utf8)!
        do {
            let object = try CleanJSONDecoder().decode(EnumStruct.self, from: data)
            XCTAssertEqual(object.enum, Enum.defaultCase)
            XCTAssertEqual(object.enum1, Enum.defaultCase)
            XCTAssertEqual(object.enum2, .case1)
            XCTAssertEqual(object.enum3, .case3)
        } catch {
            XCTAssertNil(error)
        }
    }
    
    func testToJSON() {
        let object = KeyNotFound<String>(
            string: "string",
            boolean: true,
            int: -10,
            int8: -8,
            int16: -16,
            int32: -32,
            int64: -64,
            uint: 10,
            uint8: 8,
            uint16: 16,
            uint32: 32,
            uint64: 64,
            float: 3.14,
            double: 3.141592654,
            array: ["1", "2", "3"],
            date: Date(timeIntervalSinceReferenceDate: 0),
            decimal: Decimal(0),
            data: Data(),
            object: Nested(string: "string"),
            enum: .case3,
            any: "any",
            dict: ["key": "value"])
        
        XCTAssertNotNil(object.toJSONString())
    }
}
