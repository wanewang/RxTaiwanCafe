//
//  DiskCache.swift
//  RxTaiwanCafe
//
//  Created by Wane Wang on 1/13/17.
//  Copyright © 2017 Wane. All rights reserved.
//

import Foundation

enum CacheError: Swift.Error {
    case remove(path: String)
    case create(path: String)
    case notExist
}

class DiskCache {
    
    private let fileManager: FileManager
    private let documentPath: URL
    
    init?(_ fileManager: FileManager) {
        guard let documentPath = URL(string: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]) else {
            return nil
        }
        self.fileManager = fileManager
        self.documentPath = documentPath
    }
    
    func get(at filename: String) throws -> Data {
        let filePathString = documentPath.appendingPathComponent(filename).absoluteString
        guard let data = fileManager.contents(atPath: filePathString) else {
            throw CacheError.notExist
        }
        return data
    }
    
    func save(_ data: Data, to filename: String) throws {
        let filePathString = documentPath.appendingPathComponent(filename).absoluteString
        if fileManager.fileExists(atPath: filePathString) {
            do {
                try remove(path: filePathString)
            } catch {
                throw CacheError.remove(path: filePathString)
            }
        }
        if !fileManager.createFile(atPath: filePathString, contents: data) {
            throw CacheError.create(path: filePathString)
        }
    }
    
    private func remove(path: String) throws {
        try fileManager.removeItem(atPath: path)
    }
    
}
