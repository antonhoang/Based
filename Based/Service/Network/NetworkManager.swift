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
    
    func cancelTask(for url: URL) {
        tasks[url]?.cancel()
        tasks[url] = nil
    }
    
    func encodeData<T: Encodable>(data: T) throws -> Data {
        let encoder = JSONEncoder()
        let encodedData = try encoder.encode(data)
        return encodedData
    }
}
