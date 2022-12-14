//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Rafael Levy on 10/11/22.
//

import Foundation
import CloudKit

public final class RemoteFeedLoader {
    private let url: URL
    private let client: HTTPClient
    
    public init(url: URL , client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    
    public enum Error: Swift.Error {
        case conectivity
        case invalidData
    }
    
    public enum Result: Equatable {
        case success([FeedItem])
        case failure(Error)
    }
    
   
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from:url) { result in
            switch result {
            case  let .success(data, response):
                do {
                    let items = try FeedItemsMapper.map(data, response)
                    completion(.success(items))
                } catch {
                    completion(.failure(.invalidData))
                }
                
            case .failure:
                completion(.failure(.conectivity))
            }
        }
    }
}








