//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Rafael Levy on 12/14/22.
//

import Foundation


public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}


public protocol HTTPClient {
    func get(from url:URL, completion: @escaping (HTTPClientResult) -> Void)
}
