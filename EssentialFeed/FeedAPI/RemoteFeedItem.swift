//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by Rafael Levy on 2/3/23.
//

import Foundation

internal struct RemoteFeedItem: Decodable {
    let id: UUID
    let description: String?
    let location: String?
    let image: URL
    
}
