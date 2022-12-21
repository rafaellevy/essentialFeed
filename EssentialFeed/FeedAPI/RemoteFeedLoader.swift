//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Rafael Levy on 10/11/22.
//

import Foundation
import CloudKit

public final class RemoteFeedLoader : FeedLoader {
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case conectivity
        case invalidData
    }
    
    public typealias Result = LoadFeedResult
    
    public init(url: URL , client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
   
    
   
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from:url) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case  let .success(data, response):
                completion(FeedItemsMapper.map(data: data, response: response))
            case .failure:
                completion(.failure(Error.conectivity))
            }
        }
    }
    
    
}








