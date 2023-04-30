//
//  BasedTests.swift
//  BasedTests
//
//  Created by antuan.khoanh on 30/04/2023.
//

import XCTest
@testable import Based

final class NetworkManagerTests: XCTestCase {
    
    var session: URLSession!
    var cache: NSCache<NSURL, NSData>!
    var networkManager: NetworkManager!

    override func setUpWithError() throws {
        try super.setUpWithError()
        session = URLSession(configuration: .default)
        cache = NSCache<NSURL, NSData>()
        networkManager = NetworkManager(session: session, cache: cache)
    }

    override func tearDownWithError() throws {
        session = nil
        cache = nil
        networkManager = nil
        try super.tearDownWithError()
    }
    
    func testFetchDataSuccess() {
        let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1")!
        let expectation = XCTestExpectation(description: "Fetch data completes successfully")
        networkManager.fetchData(from: url, completion: { (result: Result<TodoMock, Error>) in
            switch result {
            case .success(let todo):
                XCTAssertEqual(todo.id, 1)
                XCTAssertEqual(todo.title, "delectus aut autem")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Fetch data failed with error: \(error)")
            }
        })
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testFetchDataFailure() {
        let url = URL(string: "https://jsonplaceholder.typicode.com/invalid")!
        let expectation = XCTestExpectation(description: "Fetch data fails")
        networkManager.fetchData(from: url) { (result: Result<TodoMock, Error>) in
            switch result {
            case .success:
                XCTFail("Fetch data succeeded when it should have failed")
            case .failure:
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testFetchDataCancels() {
        let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1")!
        let expectation = XCTestExpectation(description: "Fetch data cancels")
        networkManager.fetchData(from: url) { (result: Result<TodoMock, Error>) in
            switch result {
            case .success:
                XCTFail("Fetch data succeeded when it should have been cancelled")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "cancelled")
                expectation.fulfill()
            }
        }
        networkManager.cancelTask(for: url)
        wait(for: [expectation], timeout: 5)
    }
    
    func testEncodingData() throws {
        let todo = TodoMock(userId: 1, id: 1, title: "Do something", completed: false)
        let encodedData = try networkManager.encodeData(data: todo)
        let json = try XCTUnwrap(String(data: encodedData, encoding: .utf8))
        let expected = "{\"id\":1,\"title\":\"Do something\",\"userId\":1,\"completed\":false}"
        XCTAssertEqual(json, expected)
    }
    
    struct TodoMock: Codable {
        let userId: Int
        let id: Int
        let title: String
        let completed: Bool
    }


}
