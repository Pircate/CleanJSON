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
        guard let _decoder = decoder as? CleanDecoder else {
            let container = try decoder.singleValueContainer()
            let rawValue = try container.decode(RawValue.self)
            self = Self.init(rawValue: rawValue) ?? Self.defaultCase
            return
        }
        
        guard !_decoder.decodeNull(), !_decoder.codingPath.isEmpty else {
            self = Self.defaultCase
            return
        }
        
        guard let rawValue = try _decoder.decodeIfPresent(RawValue.self) else {
            self = Self.defaultCase
            return
        }
        
        self = Self.init(rawValue: rawValue) ?? Self.defaultCase
    }
}
