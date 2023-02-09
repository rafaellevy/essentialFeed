//
//  SharedTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Rafael Levy on 2/8/23.
//

import Foundation
import EssentialFeed

public func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

public func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

