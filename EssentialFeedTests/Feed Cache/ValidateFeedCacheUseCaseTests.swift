//
//  ValidateFeedCacheUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by IrisDarka on 05/10/22.
//

import XCTest
import EssentialFeed

class ValidateFeedCacheUseCaseTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation(){
        let (_,store) = makeSUT()

        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_validateCache_deletesCacheOnRetrievalError(){
        let(sut,store) = makeSUT()
        sut.validateCache()
        store.completeRetrieval(with: anyNSError())
        XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCachedFeed])
    }
    func test_validateCache_doesNotdeletesCacheOnEmpty(){
        let(sut,store) = makeSUT()
        sut.validateCache()
        store.completeRetrievalWithEmptyCache()
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    func test_validateCache_doesNotDeleteOnLessThanSevenDaysOdlCache(){
        let feed = uniqueImageFeed()
        let fixedCurrentDate = Date()
        let lessThanSevenDaysOldTimestamp = fixedCurrentDate.adding(days: -7).adding(seconds: 1)
        let(sut,store) = makeSUT()

        sut.load{_ in }
        store.completeRetrieval(with: feed.local, timestamp: lessThanSevenDaysOldTimestamp)
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    // Mark: - Helpers
 
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line:UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy){
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(store, file: file, line: line)
        return (sut,store)
    }

}

