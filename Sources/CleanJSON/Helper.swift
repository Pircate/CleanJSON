// 
//  Helper.swift
//  CleanJSON
//
//  Created by Pircate(swifter.dev@gmail.com) on 2018/10/10
//  Copyright © 2018 Pircate. All rights reserved.
//

import Foundation

@available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
var _iso8601Formatter: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = .withInternetDateTime
    return formatter
}()

extension NSNumber {
    typealias CFType = CFNumber
    
    var _cfObject: CFType {
        return unsafeBitCast(self, to: CFType.self)
    }
    
    var _cfTypeID: CFTypeID {
        return CFNumberGetTypeID()
    }
}

public protocol _StructBridgeable {
    func _bridgeToAny() -> Any
}

public protocol _StructTypeBridgeable : _StructBridgeable {
    associatedtype _StructType
    
    func _bridgeToSwift() -> _StructType
}

extension _StructTypeBridgeable {
    public func _bridgeToAny() -> Any {
        return _bridgeToSwift()
    }
}

extension NSArray : _StructTypeBridgeable {
    public typealias _StructType = Array<Any>
    
    public func _bridgeToSwift() -> _StructType {
        return _StructType._unconditionallyBridgeFromObjectiveC(self)
    }
}

extension NSDictionary: _StructTypeBridgeable {
    public typealias _StructType = Dictionary<AnyHashable,Any>
    
    public func _bridgeToSwift() -> _StructType {
        return _StructType._unconditionallyBridgeFromObjectiveC(self)
    }
}

protocol _NSNumberCastingWithoutBridging {
  var _swiftValueOfOptimalType: Any { get }
}

private struct CFSInt128Struct {
    var high: Int64
    var low: UInt64
}

extension NSNumber: _NSNumberCastingWithoutBridging {
    
    private var int128Value: CFSInt128Struct {
        var value = CFSInt128Struct(high: 0, low: 0)
        CFNumberGetValue(_cfObject, .maxType, &value)
        return value
    }
    
    var _swiftValueOfOptimalType: Any {
        if self === kCFBooleanTrue {
            return true
        } else if self === kCFBooleanFalse {
            return false
        }
        
        let numberType = CFNumberGetType(_cfObject)
        switch numberType {
        case .sInt8Type:
            return Int(int8Value)
        case .sInt16Type:
            return Int(int16Value)
        case .sInt32Type:
            return Int(int32Value)
        case .sInt64Type:
            return int64Value < Int.max ? Int(int64Value) : int64Value
        case .float32Type:
            return floatValue
        case .float64Type:
            return doubleValue
        case .maxType:
            // If the high portion is 0, return just the low portion as a UInt64, which reasonably fixes trying to roundtrip UInt.max and UInt64.max.
            if int128Value.high == 0 {
                return int128Value.low
            } else {
                return int128Value
            }
        default:
            fatalError("unsupported CFNumberType: '\(numberType)'")
        }
    }
}

fileprivate protocol Unwrappable {
    func unwrap() -> Any?
}

extension Optional: Unwrappable {
    func unwrap() -> Any? {
        return self
    }
}

internal final class __SwiftValue : NSObject, NSCopying {
    public private(set) var value: Any
    
    static func fetch(_ object: AnyObject?) -> Any? {
        if let obj = object {
            let value = fetch(nonOptional: obj)
            if let wrapper = value as? Unwrappable, wrapper.unwrap() == nil {
                return nil
            } else {
                return value
            }
        }
        return nil
    }
    
    #if canImport(ObjectiveC)
    private static var _objCNSNullClassStorage: Any.Type?
    private static var objCNSNullClass: Any.Type? {
        if let type = _objCNSNullClassStorage {
            return type
        }
        
        let name = "NSNull"
        let maybeType = name.withCString { cString in
            return objc_getClass(cString)
        }
        
        if let type = maybeType as? Any.Type {
            _objCNSNullClassStorage = type
            return type
        } else {
            return nil
        }
    }
    
    private static var _swiftStdlibSwiftValueClassStorage: Any.Type?
    private static var swiftStdlibSwiftValueClass: Any.Type? {
        if let type = _swiftStdlibSwiftValueClassStorage {
            return type
        }
        
        let name = "__SwiftValue"
        let maybeType = name.withCString { cString in
            return objc_getClass(cString)
        }
        
        if let type = maybeType as? Any.Type {
            _swiftStdlibSwiftValueClassStorage = type
            return type
        } else {
            return nil
        }
    }
    
    #endif
    
    static func fetch(nonOptional object: AnyObject) -> Any {
        #if canImport(ObjectiveC)
        // You can pass the result of a `as AnyObject` expression to this method. This can have one of three results on Darwin:
        // - It's a SwiftFoundation type. Bridging will take care of it below.
        // - It's nil. The compiler is hardcoded to return [NSNull null] for nils.
        // - It's some other Swift type. The compiler will box it in a native __SwiftValue.
        // Case 1 is handled below.
        // Case 2 is handled here:
        if type(of: object as Any) == objCNSNullClass {
            return Optional<Any>.none as Any
        }
        // Case 3 is handled here:
        if type(of: object as Any) == swiftStdlibSwiftValueClass {
            return object
            // Since this returns Any, the object is casted almost immediately — e.g.:
            //   __SwiftValue.fetch(x) as SomeStruct
            // which will immediately unbox the native box. For callers, it will be exactly
            // as if we returned the unboxed value directly.
        }
        
        // On Linux, case 2 is handled by the stdlib bridging machinery, and case 3 can't happen —
        // the compiler will produce SwiftFoundation.__SwiftValue boxes rather than ObjC ones.
        #endif
        
        if object === kCFBooleanTrue {
            return true
        } else if object === kCFBooleanFalse {
            return false
        } else if let container = object as? __SwiftValue {
            return container.value
        } else if let val = object as? _StructBridgeable {
            return val._bridgeToAny()
        } else {
            return object
        }
    }
    
    static func store(optional value: Any?) -> NSObject? {
        if let val = value {
            return store(val)
        }
        return nil
    }
    
    static func store(_ value: Any?) -> NSObject? {
        if let val = value {
            return store(val)
        }
        return nil
    }
    
    static func store(_ value: Any) -> NSObject {
        if let val = value as? NSObject {
            return val
        } else if let opt = value as? Unwrappable, opt.unwrap() == nil {
            return NSNull()
        } else {
            let boxed = (value as AnyObject)
            if boxed is NSObject {
                return boxed as! NSObject
            } else {
                return __SwiftValue(value) // Do not emit native boxes — wrap them in Swift Foundation boxes instead.
            }
        }
    }
    
    init(_ value: Any) {
        self.value = value
    }
    
    override var hash: Int {
        if let hashable = value as? AnyHashable {
            return hashable.hashValue
        }
        return ObjectIdentifier(self).hashValue
    }
    
    override func isEqual(_ value: Any?) -> Bool {
        switch value {
        case let other as __SwiftValue:
            guard let left = other.value as? AnyHashable,
                let right = self.value as? AnyHashable else { return self === other }
            
            return left == right
        case let other as AnyHashable:
            guard let hashable = self.value as? AnyHashable else { return false }
            return other == hashable
        default:
            return false
        }
    }
    
    public func copy(with zone: NSZone?) -> Any {
        return __SwiftValue(value)
    }
    
    public static let null: AnyObject = NSNull()

    override var description: String { String(describing: value) }
}
