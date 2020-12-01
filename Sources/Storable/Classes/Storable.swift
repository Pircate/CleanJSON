// 
//  Storable.swift
//  Storable
//
//  Created by Pircate(swifter.dev@gmail.com) on 2019/3/5
//  Copyright © 2019年 Pircate. All rights reserved.
//

import Foundation

public protocol Storable {
    
    associatedtype ResponseType
    
    /// 是否允许缓存，建议只缓存可以被成功解析的数据
    var allowsStorage: (ResponseType) -> Bool { get }
    
    /// 读取缓存的响应数据
    ///
    /// - Parameter key: 缓存的键
    /// - Returns: 缓存的响应数据
    /// - Throws: 读取缓存可能产生的错误
    func cachedResponse(for key: StoringKey) throws -> ResponseType
    
    /// 存储缓存的响应数据
    ///
    /// - Parameters:
    ///   - cachedResponse: 缓存的响应数据
    ///   - key: 缓存的键
    /// - Throws: 存储缓存可能产生的错误
    func storeCachedResponse(_ cachedResponse: ResponseType, for key: StoringKey) throws
    
    /// 移除缓存的响应数据
    ///
    /// - Parameter key: 缓存的键
    /// - Throws: 移除缓存可能产生的错误
    func removeCachedResponse(for key: StoringKey) throws
    
    /// 移除所有的缓存数据
    ///
    /// - Throws: 移除缓存可能产生的错误
    func removeAllCachedResponses() throws
}
