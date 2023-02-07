//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by Rafael Levy on 2/2/23.
//

import Foundation

public enum RetrieveCacheFeedResult {
    case empty
    case found(feed: [LocalFeedImage], timestamp: Date)
    case failure(Error)
    
}

public protocol FeedStore {
    
    func deleteCachedFeed(completion: @escaping (Error?) -> Void)
    
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping (Error?) -> Void )
    
    func retrieve(completion:@escaping (RetrieveCacheFeedResult) -> Void)
}



