//
//  FeedCacheTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Rafael Levy on 2/8/23.
//

import Foundation
import EssentialFeed


public func uniqueImage() -> FeedImage {
    return FeedImage(id: UUID(), description: "any", location: "any", url: anyURL())
}

public func uniqueImageFeed() -> (models: [FeedImage], local: [LocalFeedImage]) {
    let models = [uniqueImage(), uniqueImage()]
    let local = models.map { LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url)}
    
    return (models,local)
}


public extension Date {
func adding(days: Int) -> Date {
    return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
}

func adding(seconds: TimeInterval) -> Date {
    return self + seconds
}
}
