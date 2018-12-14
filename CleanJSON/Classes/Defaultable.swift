// 
//  Defaultable.swift
//  CleanJSON
//
//  Created by Pircate(gao497868860@gmail.com) on 2018/12/14
//  Copyright © 2018 Pircate. All rights reserved.
//

protocol Defaultable {
    static var defaultValue: Self { get }
}

extension Bool: Defaultable {
    static var defaultValue: Bool {
        return false
    }
}

extension Int: Defaultable {
    static var defaultValue: Int {
        return 0
    }
}

extension UInt: Defaultable {
    static var defaultValue: UInt {
        return 0
    }
}

extension Float: Defaultable {
    static var defaultValue: Float {
        return 0
    }
}

extension Double: Defaultable {
    static var defaultValue: Double {
        return 0
    }
}

extension String: Defaultable {
    static var defaultValue: String {
        return ""
    }
}
