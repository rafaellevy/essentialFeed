//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Rafael Levy on 10/9/22.
//

import Foundation


public protocol FeedLoader {
    typealias Result = Swift.Result<[FeedImage],Error>
    func load(completion: @escaping (Result) -> Void)
}
