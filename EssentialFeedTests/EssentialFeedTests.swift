//
//  EssentialFeedTests.swift
//  EssentialFeedTests
//
//  Created by Rafael Levy on 10/10/22.
//

import XCTest
import EssentialFeed

class EssentialFeedTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_RequestsDataFromURL(){
        let url = URL(string: "https://www.a-url")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        
        
        XCTAssertEqual(client.requestedURLs,[url])
    }
    
    func test_loadTwice_requestsDataFromURLTwice(){
        let url = URL(string: "https://www.a-url")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs,[url,url])
    }
    
    func test_load_deliversErrorOnClientError(){
        let url = URL(string: "https://www.a-url")!
        let (sut, client) = makeSUT(url: url)
        
        var capturedErrors = [RemoteFeedLoader.Error]()
        sut.load { capturedErrors.append($0) }
        
        let clientError = NSError(domain: "Test", code: 0)
        
        client.complete(with: clientError)
        
        
        XCTAssertEqual(capturedErrors, [.conectivity])
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse(){
        let url = URL(string: "https://www.a-url")!
        let (sut, client) = makeSUT(url: url)
        
        
        
        let samples = [199,201,300,400,500]
        
        samples.enumerated().forEach { index, code in
            
            var capturedErrors = [RemoteFeedLoader.Error]()
            
            sut.load { capturedErrors.append($0) }

            
            client.complete(withStatusCode: code, at: index)
            
            XCTAssertEqual(capturedErrors, [.invalidData])
        }
        
        
    }
    
    func test_load_deliversErrorOnNon200HTTPResponseWithInvalidJSON(){
        let url = URL(string: "https://www.a-url")!
        let (sut, client) = makeSUT(url: url)
        
        var capturedErrors = [RemoteFeedLoader.Error]()
        
        sut.load { capturedErrors.append($0) }

        let invalidJSON = Data(bytes: "Invalid Data".utf8)
        client.complete(withStatusCode: 200, data: invalidJSON)
        
        XCTAssertEqual(capturedErrors, [.invalidData])
        
        
    }
    
    // Helpers
    
    private func makeSUT(url: URL = URL(string: "https://www.a-url")!) -> (RemoteFeedLoader,HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (sut,client)
    }
    
    private class HTTPClientSpy: HTTPClient {
    
        private var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()
        
        var requestedURLs : [URL] {
            return messages.map { $0.url }
        }
        
        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            return messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, data: Data = Data(), at index: Int = 0) {
            
            let response = HTTPURLResponse(url: requestedURLs[index],
                                           statusCode: code,
                                           httpVersion: nil,
                                           headerFields: nil)!
            
            return messages[index].completion(.success(data, response))
            
        }
    }
    
    

}
