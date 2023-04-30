//
//  HTTPRequest.swift
//  Based
//
//  Created by antuan.khoanh on 30/04/2023.
//

import Foundation

protocol HTTPRequest {
    associatedtype Response: Decodable
    
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var parameters: [String: Any]? { get }
    var body: Data? { get }
    
    func urlRequest() throws -> URLRequest
    func decodeResponse(data: Data) throws -> Response
}

extension HTTPRequest {
    var baseURL: URL { return URL(string: "https://example.com")! }
    var headers: [String: String] { return [:] }
    var parameters: [String: Any]? { return nil }
    var body: Data? { return nil }
    
    func urlRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        headers.forEach { key, value in
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        if let parameters {
            guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                throw NetworkError.invalidURL
            }
            var queryItems: [URLQueryItem] = []
            for (key, value) in parameters {
                queryItems.append(URLQueryItem(name: key, value: "\(value)"))
            }
            if !queryItems.isEmpty {
                var urlComponents = components
                urlComponents.queryItems = queryItems
                urlRequest.url = urlComponents.url
            }
        }
        if let body {
            urlRequest.httpBody = body
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        return urlRequest
    }
    
    func decodeResponse(data: Data) throws -> Response {
        let decoder = JSONDecoder()
        return try decoder.decode(Response.self, from: data)
    }
}
