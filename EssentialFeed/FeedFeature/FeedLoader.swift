//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Rafael Levy on 10/9/22.
//

import Foundation

public enum LoadFeedResult {
    case success([FeedImage])
    case failure(Error)
}

public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
