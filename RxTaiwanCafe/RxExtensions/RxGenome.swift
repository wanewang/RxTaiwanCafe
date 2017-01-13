//
//  RxGenome.swift
//  RxTaiwanCafe
//
//  Created by Wane Wang on 1/13/17.
//  Copyright © 2017 Wane. All rights reserved.
//

import Foundation
import RxSwift
import Genome

extension ObservableType where E == Data {
    
    func mapObject<T: MappableObject>(type: T.Type, path: String? = nil) -> Observable<T> {
        return observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map { data -> T in
                let node = try data.makeNode()
                guard let path = path else {
                    return try T(node: node)
                }
                guard let pathNode = node[path: path]?.node else {
                    throw APIError.mapping(path: path, text: String.init(data: data, encoding: .utf8))
                }
                return try T(node: pathNode)
            }.observeOn(MainScheduler.instance)
    }
    
    func mapObjects<T: MappableObject>(type: T.Type, path: String? = nil) -> Observable<[T]> {
        return observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map { data -> [T] in
                let node = try data.makeNode()
                guard let path = path else {
                    return try [T](node: node)
                }
                guard let pathNode = node[path: path]?.node else {
                    throw APIError.mapping(path: path, text: String.init(data: data, encoding: .utf8))
                }
                return try [T](node: pathNode)
            }.observeOn(MainScheduler.instance)
    }
    
}

