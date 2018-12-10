// 
//  CaseDefaultable.swift
//  CleanJSON
//
//  Created by Pircate(gao497868860@gmail.com) on 2018/11/30
//  Copyright © 2018 Pircate. All rights reserved.
//
//  Reference: https://github.com/line/line-sdk-ios-swift/blob/master/LineSDK/LineSDK/Networking/Model/CustomizeCoding/CodingExtension.swift

public protocol CaseDefaultable: RawRepresentable {
    static var defaultCase: Self { get }
}

public extension CaseDefaultable where Self: Decodable, Self.RawValue: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        guard let jsonDecoder = container as? _CleanJSONDecoder else {
            let rawValue = try container.decode(RawValue.self)
            self = Self.init(rawValue: rawValue) ?? Self.defaultCase
            return
        }
        self = try jsonDecoder.decodeCase(Self.self)
    }
}

private extension _CleanJSONDecoder {
    func decodeCase<T>(_ type: T.Type) throws -> T
        where T: CaseDefaultable,
        T: Decodable,
        T.RawValue: Decodable
    {
        if decodeNil() {
            return T.defaultCase
        }
        
        guard self.storage.topContainer is T.RawValue else {
            return T.defaultCase
        }
        
        let rawValue = try decode(T.RawValue.self)
        return T.init(rawValue: rawValue) ?? T.defaultCase
    }
}
