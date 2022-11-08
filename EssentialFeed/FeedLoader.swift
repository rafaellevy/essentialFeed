//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Rafael Levy on 10/9/22.
//

import Foundation

enum LoadFeedResult {
    case success([FeedItem])
    case error(Error)
}

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
