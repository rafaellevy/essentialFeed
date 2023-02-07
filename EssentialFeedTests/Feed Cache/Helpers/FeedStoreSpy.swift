//
//  FeedStoreSpy.swift
//  EssentialFeedTests
//
//  Created by Rafael Levy on 2/6/23.
//

import EssentialFeed

class FeedStoreSpy: FeedStore {
    enum ReceivedMessage: Equatable {
        case deleteCachedFeed
        case insert([LocalFeedImage], Date)
        case retrieve
    }
    
    var receivedMessages = [ReceivedMessage]()
    
//    var retrieveMessages = [ReceivedMessage]()

    private var deletionCompletions = [(Error?) -> Void]()
    
    private var insertionCompletions = [(Error?) -> Void]()
    
    private var retrievalCompletions = [(Error?) -> Void]()
    
    
    
    
    
    func deleteCachedFeed(completion: @escaping (Error?) -> Void) {
        deletionCompletions.append(completion)
        receivedMessages.append(.deleteCachedFeed)
    }
    
    
    func completeDeletion(with error: Error, at index: Int = 0) {
        deletionCompletions[index](error)
    }
    
    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionCompletions[index](nil)
    }
    
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping (Error?) -> Void ) {
        insertionCompletions.append(completion)
        receivedMessages.append(.insert(feed, timestamp))
    }
    
    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionCompletions[index](error)
        
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionCompletions[index](nil)
    }
    
    func retrieve(completion: @escaping(Error?) -> Void) {
        retrievalCompletions.append(completion)
        receivedMessages.append(.retrieve)
    }
    func completeRetrieval(with error: Error, at index: Int = 0) {
        retrievalCompletions[index](error)
        
    }
    
    func completeRetrievalWithEmptyCache(at index: Int = 0) {
        retrievalCompletions[index](nil)
    }
}
