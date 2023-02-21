//
//  FeedCachePolicy.swift
//  EssentialFeed
//
//  Created by Rafael Levy on 2/20/23.
//

import Foundation

final class FeedCachePolicy {
    private init() {}
     static private let calendar = Calendar(identifier: .gregorian)


     static private var maxCacheAgeInDays: Int {
         return 7
     }

     static func validate(_ timestamp: Date, against date: Date) -> Bool {
         guard let maxCacheAge = calendar.date(byAdding: .day, value: maxCacheAgeInDays, to: timestamp) else {
             return false
         }
        
         return date < maxCacheAge
     }
 }
