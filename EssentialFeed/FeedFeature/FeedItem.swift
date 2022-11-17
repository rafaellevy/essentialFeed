//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by Rafael Levy on 11/17/22.
//

import Foundation

public struct FeedItem: Equatable {
    let id: UUID
    let description: String?
    let location: String?
    let imageURL: URL
}
