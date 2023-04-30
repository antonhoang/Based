//
//  GetRequestExample.swift
//  Based
//
//  Created by antuan.khoanh on 30/04/2023.
//

import Foundation

struct GetRequestExample<R: Decodable>: HTTPRequest {
    typealias Response = R
    
    var baseURL: URL {
        return URL(string: "https://example.com")!
    }
    
    var path: String {
        return "/api/get"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: [String: Any]? {
        return ["key": "value"]
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
    
    func body() throws -> Data? {
        return nil
    }
}
