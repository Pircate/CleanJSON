//
//  JSONDecoderImpl.swift
//  CleanJSON
//
//  Created by Pircate(swifter.dev@gmail.com) on 2021/12/16
//  Copyright © 2021 Pircate. All rights reserved.
//

import Foundation

struct JSONDecoderImpl {
    let codingPath: [CodingKey]
    let userInfo: [CodingUserInfoKey: Any]

    let json: JSONValue
    let options: CleanJSONDecoder.Options

    init(
        userInfo: [CodingUserInfoKey: Any],
        from json: JSONValue,
        codingPath: [CodingKey],
        options: CleanJSONDecoder.Options
    ) {
        self.userInfo = userInfo
        self.codingPath = codingPath
        self.json = json
        self.options = options
    }
}
