//
//  LoadFeedFromCacheUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Rafael Levy on 2/6/23.
//

import XCTest
import EssentialFeed


class LoadFeedFromCacheUseCaseTests: XCTestCase {
   
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMessages, [] )
    }
    
    func test_load_requestCacheRetrival() {
        let (sut, store) = makeSUT()
        
        sut.load { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
        
        
    }
    
    func test_load_failsOnRetrivalWithError() {
        let (sut, store) = makeSUT()
        
        let retrievalError = anyNSError()
        
        expect(sut, toCompleteWith: .failure(retrievalError)) {
            store.completeRetrieval(with: retrievalError)
        }
        
    }
    
    func test_load_deliversNoImageOnEmptyCache() {
        let (sut, store) = makeSUT()
    
        
        expect(sut,toCompleteWith: .success([])) {
            store.completeRetrievalWithEmptyCache()
        }

    }
    
    func test_load_deliversCachedImagesOnLessThanSevenDaysOldCache() {
        let feed = uniqueImageFeed()
        let fixedCurrentDate = Date()
        let lessThanSevenDaysTimestamp = fixedCurrentDate.adding(days: -7).adding(seconds:1)
        let (sut, store) = makeSUT { fixedCurrentDate }
    
        
        expect(sut,toCompleteWith: .success(feed.models)) {
            store.completeRetrieval(with: feed.local, timestamp: lessThanSevenDaysTimestamp)
        }

    }
    
    func test_load_deliversNoImagesOnSevenDaysOldCache() {
        let feed = uniqueImageFeed()
        let fixedCurrentDate = Date()
        let sevenDaysTimestamp = fixedCurrentDate.adding(days: -7)
        let (sut, store) = makeSUT { fixedCurrentDate }
    
        
        expect(sut, toCompleteWith: .success([])) {
            store.completeRetrieval(with: feed.local, timestamp: sevenDaysTimestamp)
        }
        
    }
    
    func test_load_deliversNoImagesOnMoreThanSevenDaysOldCache() {
        let feed = uniqueImageFeed()
        let fixedCurrentDate = Date()
        let moreThanSevenDaysTimestamp = fixedCurrentDate.adding(days: -7).adding(seconds: -1)
        let (sut, store) = makeSUT { fixedCurrentDate }
    
        
        expect(sut, toCompleteWith: .success([])) {
            store.completeRetrieval(with: feed.local, timestamp: moreThanSevenDaysTimestamp)
        }
        
    }
    
    func test_load_deletesCacheOnRetrievalError() {
        
        let (sut, store) = makeSUT()
        sut.load { _ in }
        store.completeRetrieval(with: anyNSError())
        
        XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCachedFeed])
        
    }
    
    func test_load_doesNotDeletesCacheOnEmptyCache() {
        
        let (sut, store) = makeSUT()
        sut.load { _ in }
        store.completeRetrievalWithEmptyCache()
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
        
    }
    
    func test_load_doesNotDeletesCacheOnLessThanSevenDaysOldCache() {
        let feed = uniqueImageFeed()
        let fixedCurrentDate = Date()
        let lessThanSevenDaysTimestamp = fixedCurrentDate.adding(days: -7).adding(seconds: 1)
        let (sut, store) = makeSUT { fixedCurrentDate }
    
        sut.load { _ in}
        
        store.completeRetrieval(with: feed.local, timestamp: lessThanSevenDaysTimestamp)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
        
    }
    
    func test_load_deletesCacheOnSevenDaysOldCache() {
        let feed = uniqueImageFeed()
        let fixedCurrentDate = Date()
        let sevenDaysOldTimestamp = fixedCurrentDate.adding(days: -7)
        let (sut, store) = makeSUT { fixedCurrentDate }
    
        sut.load { _ in}
        
        store.completeRetrieval(with: feed.local, timestamp: sevenDaysOldTimestamp)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCachedFeed])
        
    }
    
    func test_load_deletesCacheOnMoreThanSevenDaysOldCache() {
        let feed = uniqueImageFeed()
        let fixedCurrentDate = Date()
        let moreThanSevenDaysOldTimestamp = fixedCurrentDate.adding(days: -7).adding(seconds: -1)
        let (sut, store) = makeSUT { fixedCurrentDate }
    
        sut.load { _ in}
        
        store.completeRetrieval(with: feed.local, timestamp: moreThanSevenDaysOldTimestamp)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCachedFeed])
        
    }
    
    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let store = FeedStoreSpy()
        var sut : LocalFeedLoader? = LocalFeedLoader(store: store, currentDate: Date.init)
        var receivedResults = [LoadFeedResult]()
        sut?.load { receivedResults.append($0) }
        sut = nil
                         
        store.completeRetrievalWithEmptyCache()
        
        XCTAssertTrue(receivedResults.isEmpty)
        
    }
    
    
    
    
    // MARK: Helpers
    private func makeSUT(currentDate: @escaping () -> Date = Date.init , file: StaticString = #filePath, line: UInt = #line) -> (sut:LocalFeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        trackForMemoryLeak(store, file: file , line: line)
        trackForMemoryLeak(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func expect(_ sut: LocalFeedLoader, toCompleteWith expectedResult: LoadFeedResult, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line ) {
        
        let exp = expectation(description: "Wait for load completion")
        
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedImages),.success(expectedImages)):
                XCTAssertEqual(receivedImages, expectedImages, file: file, line: line)
            case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            default:
                XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
        
            exp.fulfill()
        }
        action()
        wait(for: [exp], timeout: 1.0)
    }

    
    private func anyURL() -> URL {
        return URL(string: "http://any-url.com")!
    }
    
    private func anyData() -> Data {
        return Data(bytes: "any data".utf8)
    }
    
    private func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 0)
    }
    
    private func uniqueImage() -> FeedImage {
        return FeedImage(id: UUID(), description: "any", location: "any", url: anyURL())
    }
    
    private func uniqueImageFeed() -> (models: [FeedImage], local: [LocalFeedImage]) {
        let models = [uniqueImage(), uniqueImage()]
        let local = models.map { LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url)}
        
        return (models,local)
    }
}

private extension Date {
    func adding(days: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }
    
    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }
}




