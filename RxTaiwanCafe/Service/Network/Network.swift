//
//  Network.swift
//  RxTaiwanCafe
//
//  Created by Wane Wang on 10/6/16.
//  Copyright © 2016 OptimisCorp. All rights reserved.
//

import Foundation
import RxSwift


enum APIError: Error, CustomStringConvertible {
    case invalidResponse
    case notFound
    case mapping(path: String, text: String?)
    
    var description: String {
        switch self {
        case .invalidResponse: return "Received an invalid response"
        case .notFound: return "Requested item was not found"
        case .mapping(let path, let response): return "Mapped path: \(path) was not found\n response: \(response)"
        }
    }
}

enum NetworkError: Error, CustomStringConvertible {
    case unknown
    case invalidResponse
    case noNetwork

    var description: String {
        switch self {
        case .unknown: return "An unknown error occurred"
        case .invalidResponse: return "Received an invalid response"
        case .noNetwork: return "No network connection"
        }
    }
}

protocol NetworkCancelable {
    func cancel()
}
extension URLSessionDataTask: NetworkCancelable {}

protocol Network {

    func json(_ request: NetworkRequest) -> Observable<Any>
    func data(_ request: NetworkRequest) -> Observable<Data>
}
