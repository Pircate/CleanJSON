import XCTest
import CleanJSON

struct ValueNotFound<T: Codable>: Codable {
    let null: T
}

struct KeyNotFound: Codable {
    let string: String
    let boolean: Bool
    let int: Int
    let uint: UInt
    let float: Float
    let double: Double
    let array: [String]
    let object: Nested
    let `enum`: Enum
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
}

struct EnumStruct: Codable {
    let `enum`: Enum
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
            let object = try CleanJSONDecoder().decode(KeyNotFound.self, from: data)
            XCTAssertEqual(object.string, "")
            XCTAssertEqual(object.boolean, false)
            XCTAssertEqual(object.int, 0)
            XCTAssertEqual(object.uint, 0)
            XCTAssertEqual(object.float, 0)
            XCTAssertEqual(object.double, 0)
            XCTAssertEqual(object.array, [])
            XCTAssertEqual(object.object.string, "")
            XCTAssertEqual(object.enum, Enum.defaultCase)
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
            XCTAssertEqual(object.boolToString, "true")
            XCTAssertEqual(object.intToString, "10")
            XCTAssertEqual(object.doubleToString, "3.14")
        } catch {
            XCTAssertNil(error)
        }
    }
    
    func testCustomTypeConvertion() {
        let data = """
                    {
                      "null": null,
                      "stringToInt": "1,314",
                      "stringToDouble": "3.141592654",
                      "boolToString": true,
                      "doubleToString": 3.14,
                      "intToString": 10
                    }
                """.data(using: .utf8)!
        
        do {
            let decoder = CleanJSONDecoder()
            var adaptor = CleanJSONDecoder.Adaptor()
            adaptor.decodeString = { decoder in
                if let intValue = try decoder.decodeIfPresent(Int.self) {
                    return "$" + String(intValue)
                } else if let doubleValue = try decoder.decodeIfPresent(Double.self) {
                    return String(format: "%.f", doubleValue)
                } else if let boolValue = try decoder.decodeIfPresent(Bool.self) {
                    return String(boolValue).uppercased()
                }
                return ""
            }
            adaptor.decodeInt = { decoder in
                if let stringValue = try decoder.decodeIfPresent(String.self) {
                    let formatter = NumberFormatter()
                    formatter.generatesDecimalNumbers = true
                    formatter.numberStyle = .decimal
                    return formatter.number(from: stringValue)?.intValue ?? 0
                }
                return 0
            }
            adaptor.decodeDouble = { decoder in
                if let stringValue = try decoder.decodeIfPresent(String.self) {
                    return Double(stringValue)?.advanced(by: 1) ?? 0
                }
                return 0
            }
            adaptor.decodeBool = { decoder in
                if decoder.decodeNull() {
                    return true
                }
                return false
            }
            decoder.keyNotFoundDecodingStrategy = .useDefaultValue
            decoder.valueNotFoundDecodingStrategy = .custom(adaptor)
            let object = try decoder.decode(TypeMismatch.self, from: data)
            XCTAssertEqual(object.null, true)
            XCTAssertEqual(object.stringToInt, 1314)
            XCTAssertEqual(object.stringToDouble, 4.141592654)
            XCTAssertEqual(object.boolToString, "TRUE")
            XCTAssertEqual(object.intToString, "$10")
            XCTAssertEqual(object.doubleToString, "3")
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
    
    func testOptional() {
        let data = """
                    {
                      "string": null,
                      "uint": 10,
                      "float": 4.9
                    }
                """.data(using: .utf8)!
        do {
            let object = try CleanJSONDecoder().decode(Optional.self, from: data)
            XCTAssertNil(object.string)
            XCTAssertNil(object.boolean)
            XCTAssertNil(object.int)
            XCTAssertEqual(object.uint, 10)
            XCTAssertEqual(object.float, 4.9)
            XCTAssertNil(object.double)
        } catch {
            XCTAssertNil(error)
        }
    }
    
    func testEnumDefaultCase() {
        let data = """
                    {
                      "enum": 3,
                    }
                """.data(using: .utf8)!
        do {
            let object = try CleanJSONDecoder().decode(EnumStruct.self, from: data)
            XCTAssertEqual(object.enum, Enum.defaultCase)
        } catch {
            XCTAssertNil(error)
        }
    }
    
    func testToJSON() {
        let object = KeyNotFound(string: "string", boolean: true, int: -10, uint: 10, float: 3.14, double: 3.141592654, array: ["1", "2", "3"], object: Nested(string: "string"), enum: .case3)
        do {
            _ = try object.toJSONString()
        } catch {
            XCTAssertNil(error)
        }
    }
}
