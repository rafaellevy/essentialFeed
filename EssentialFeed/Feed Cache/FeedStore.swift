//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by Rafael Levy on 2/2/23.
//

import Foundation

public protocol FeedStore {
    
    func deleteCachedFeed(completion: @escaping (Error?) -> Void)
    
    func insert(_ items: [LocalFeedImage], timestamp: Date, completion: @escaping (Error?) -> Void )
}



