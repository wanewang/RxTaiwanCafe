//
//  NetworkRequest.swift
//  RxTaiwanCafe
//
//  Created by Wane Wang on 10/6/16.
//  Copyright © 2016 OptimisCorp. All rights reserved.
//

import Foundation

enum NetworkRequestError: Error, CustomStringConvertible {
    case invalidURL(String)
    case invalidParameter([String: Any])

    var description: String {
        switch self {
        case .invalidURL(let url): return "The url '\(url)' was invalid"
        case .invalidParameter(let parameter): return "The parameter \(parameter) was invalid"
        }
    }
}

struct NetworkRequest {
    // MARK: - HTTP Methods
    enum Method: String {
        case get        = "GET"
        case put        = "PUT"
        case patch      = "PATCH"
        case post       = "POST"
        case delete     = "DELETE"
    }

    // MARK: - Public Properties
    let method: NetworkRequest.Method
    let url: String
    let headers: [(header: String, value: String)]
    let parameters: [String: Any]

    init(method: NetworkRequest.Method, url:String, parameters: [String: Any] = [:], headers: [(header: String, value: String)] = []) {
        self.method = method
        self.url = url
        self.headers = headers
        self.parameters = parameters
    }
    
    // MARK: - Public Functions
    func buildURLRequest() throws -> URLRequest {
        
        var request: URLRequest
        if method == .get {
            guard var component = URLComponents(string: url) else {
                throw NetworkRequestError.invalidURL(self.url)
            }
            component.queryItems = parameters.flatMap {
                URLQueryItem.init(name: $0.key, value: "\($0.value)")
            }
            
            guard let url = component.url else {
                throw NetworkRequestError.invalidParameter(parameters)
            }
            request = URLRequest(url: url)
        } else {
            guard let u = URL(string: url) else {
                throw NetworkRequestError.invalidURL(url)
            }
            request = URLRequest(url: u)
            request.httpBody = query(parameters).data(using: .utf8)
            
        }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = method.rawValue
        for header in headers {
            request.setValue(header.value, forHTTPHeaderField: header.header)
        }
        return request
    }
    
    private func query(_ parameters: [String: Any]) -> String {
        var components: [(String, String)] = []
        
        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += queryComponents(fromKey: key, value: value)
        }
        
        return components.map { "\($0)=\($1)" }.joined(separator: "&")
    }
    public func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
        var components: [(String, String)] = []
        
        if let dictionary = value as? [String: Any] {
            for (nestedKey, value) in dictionary {
                components += queryComponents(fromKey: "\(key)[\(nestedKey)]", value: value)
            }
        } else if let array = value as? [Any] {
            for value in array {
                components += queryComponents(fromKey: "\(key)[]", value: value)
            }
        } else if let value = value as? NSNumber {
            if value.isBool {
                components.append((escape(key), escape((value.boolValue ? "1" : "0"))))
            } else {
                components.append((escape(key), escape("\(value)")))
            }
        } else if let bool = value as? Bool {
            components.append((escape(key), escape((bool ? "1" : "0"))))
        } else {
            components.append((escape(key), escape("\(value)")))
        }
        
        return components
    }
    public func escape(_ string: String) -> String {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        
        var escaped = ""
        
        //==========================================================================================================
        //
        //  Batching is required for escaping due to an internal bug in iOS 8.1 and 8.2. Encoding more than a few
        //  hundred Chinese characters causes various malloc error crashes. To avoid this issue until iOS 8 is no
        //  longer supported, batching MUST be used for encoding. This introduces roughly a 20% overhead. For more
        //  info, please refer to:
        //
        //      - https://github.com/Alamofire/Alamofire/issues/206
        //
        //==========================================================================================================
        if #available(iOS 8.3, *) {
            escaped = string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
        } else {
            let batchSize = 50
            var index = string.startIndex
            
            while index != string.endIndex {
                let startIndex = index
                let endIndex = string.index(index, offsetBy: batchSize, limitedBy: string.endIndex) ?? string.endIndex
                let range = startIndex..<endIndex
                
                let substring = string.substring(with: range)
                
                escaped += substring.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? substring
                
                index = endIndex
            }
        }
        
        return escaped
    }
}

extension NSNumber {
    fileprivate var isBool: Bool { return CFBooleanGetTypeID() == CFGetTypeID(self) }
}
