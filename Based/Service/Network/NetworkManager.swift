//
//  NetworkManager.swift
//  Based
//
//  Created by antuan.khoanh on 30/04/2023.
//

import Foundation

typealias NetworkCompletion<T> = (Result<T, Error>) -> Void

class NetworkManager {
    
    private let session: URLSession
    private var cache: NSCache<NSURL, NSData>
    private var tasks: [URL: URLSessionDataTask] = [:]
    private var taskCache: [URLSessionDataTask: URL] = [:]
    
    init(session: URLSession = .shared, cache: NSCache<NSURL, NSData> = NSCache<NSURL, NSData>()) {
        self.session = session
        self.cache = cache
    }
    
    func fetchData<T: Decodable>(from url: URL, completion: @escaping NetworkCompletion<T>) {
        if let cachedData = cache.object(forKey: url as NSURL) {
            if let decodedData = try? JSONDecoder().decode(T.self, from: cachedData as Data) {
                completion(.success(decodedData))
                return
            }
        }
        let task = session.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            self.tasks[url] = nil
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                let error = NSError(domain: "NetworkError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid HTTP response"])
                completion(.failure(error))
                return
            }
            guard let data = data else {
                let error = NSError(domain: "NetworkError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(error))
                return
            }
            if let decodedData = try? JSONDecoder().decode(T.self, from: data) {
                self.cache.setObject(data as NSData, forKey: url as NSURL)
                completion(.success(decodedData))
            } else {
                let error = NSError(domain: "NetworkError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unable to decode data"])
                completion(.failure(error))
            }
        }
        
        tasks[url] = task
        task.resume()
    }
    
    func sendRequest<T: Codable>(_ request: any HTTPRequest, completion: @escaping (Result<T, Error>) -> Void) {
        do {
            let urlRequest = try request.urlRequest()
            let task = session.dataTask(with: urlRequest) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                } else if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(T.self, from: data)
                        completion(.success(result))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    let emptyResponseError = NetworkError.emptyResponse
                    completion(.failure(emptyResponseError))
                }
            }
            task.resume()
        } catch {
            completion(.failure(error))
        }
    }
    
    func cancelTask(for url: URL) {
        tasks[url]?.cancel()
        tasks[url] = nil
    }
    
    func encodeData<T: Encodable>(data: T) throws -> Data {
        let encoder = JSONEncoder()
        let encodedData = try encoder.encode(data)
        return encodedData
    }
    
    func downloadData(url: URL, cache: Bool = true, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask {
        if let cachedData = getCachedData(for: url) {
            completion(.success(cachedData))
            return URLSessionDataTask()
        }
        let emptyResponseError = NetworkError.emptyResponse
        let task = session.dataTask(with: url) { [weak self] (data, response, error) in
            guard let task = self?.taskCache.first(where: { $0.value == url })?.key else {
                return
            }
            defer {
                self?.taskCache.removeValue(forKey: task)
            }
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                if cache {
                    self?.cacheData(data, for: url)
                }
                completion(.success(data))
            } else {
                completion(.failure(emptyResponseError))
            }
        }
        taskCache[task] = url
        task.resume()
        return task
    }
    
    func cancelDownload(task: URLSessionDataTask) {
        task.cancel()
        taskCache.removeValue(forKey: task)
    }
    
    private func getCachedData(for url: URL) -> Data? {
        let request = URLRequest(url: url)
        return session.configuration.urlCache?.cachedResponse(for: request)?.data
    }
    
    private func cacheData(_ data: Data, for url: URL) {
        let request = URLRequest(url: url)
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        let cachedResponse = CachedURLResponse(response: response, data: data)
        session.configuration.urlCache?.storeCachedResponse(cachedResponse, for: request)
    }
    
}

enum NetworkError: Error {
    case emptyResponse
    case invalidURL
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

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
