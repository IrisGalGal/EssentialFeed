//
//  LoadFeedFromCacheUseCaseTest.swift
//  EssentialFeedTests
//
//  Created by IrisGal on 03/10/22.
//

import XCTest
import EssentialFeed

class LoadFeedFromCacheUseCaseTest: XCTestCase {

    func test_init_doesNotMessageStoreUponCreation(){
        let (_,store) = makeSUT()

        XCTAssertEqual(store.receivedMessages, [])
    }
    func test_load_requestsCacheRetrival(){
        let(sut,store) = makeSUT()
        sut.load{_ in }
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    func test_load_failsOnRetrievalError(){
        let(sut,store) = makeSUT()
        let retrievalError = anyNSError()
        expect(sut, toCompleteWith: .failure(retrievalError)) {
            store.completeRetrieval(with: retrievalError)
        }
    }
    func test_load_deliverNoImagesOnEmptyCache(){
        let(sut,store) = makeSUT()
        expect(sut, toCompleteWith: .success([])) {
            store.completeRetrievalWithEmptyCache()
        }
    }
    func test_load_deliverCachedImagesOnNonExpiredCache(){
        let feed = uniqueImageFeed()
        let fixedCurrentDate = Date()
        let nonExpiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: 1)
        let(sut,store) = makeSUT {
            fixedCurrentDate
        }
        expect(sut, toCompleteWith: .success(feed.models)) {
            store.completeRetrieval(with: feed.local, timestamp: nonExpiredTimestamp)
        }

    }
    func test_load_deliverNoImagesOnCacheExpiration(){
        let feed = uniqueImageFeed()
        let fixedCurrentDate = Date()
        let expiratitonTimestamp = fixedCurrentDate.minusFeedCacheMaxAge()
        let(sut,store) = makeSUT {
            fixedCurrentDate
        }
        expect(sut, toCompleteWith: .success([])) {
            store.completeRetrieval(with: feed.local, timestamp: expiratitonTimestamp)
        }

    }
    func test_load_deliverNoImagesOnExpiredCache(){
        let feed = uniqueImageFeed()
        let fixedCurrentDate = Date()
        let expiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(days: -1)
        let(sut,store) = makeSUT {
            fixedCurrentDate
        }
        expect(sut, toCompleteWith: .success([])) {
            store.completeRetrieval(with: feed.local, timestamp: expiredTimestamp)
        }

    }
    func test_load_hasNoSideEffectseOnRetrievalError(){
        let(sut,store) = makeSUT()
        sut.load{ _ in}
        store.completeRetrieval(with: anyNSError())
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_hasNoSideEffectsOnEmptyCache(){
        let(sut,store) = makeSUT()
        sut.load{ _ in}
        store.completeRetrieval(with: anyNSError())
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    func test_load_hasNoSideEffectsOnNonExpiredCache(){
        let feed = uniqueImageFeed()
        let fixedCurrentDate = Date()
        let nonExpiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: 1)
        let(sut,store) = makeSUT()

        sut.load{_ in }
        store.completeRetrieval(with: feed.local, timestamp: nonExpiredTimestamp)
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    func test_load_hasNoSideEffectsOnCacheExpiration(){
        let feed = uniqueImageFeed()
        let fixedCurrentDate = Date()
        let expirationTimestamp = fixedCurrentDate.adding(days: -7)
        let(sut,store) = makeSUT(currentDate: {fixedCurrentDate})

        sut.load{_ in }
        store.completeRetrieval(with: feed.local, timestamp: expirationTimestamp)
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    func test_load_hasNoSideEffectsOnExpiredCache(){
        let feed = uniqueImageFeed()
        let fixedCurrentDate = Date()
        let expiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(days: -1)
        let(sut,store) = makeSUT(currentDate: {fixedCurrentDate})

        sut.load{_ in }
        store.completeRetrieval(with: feed.local, timestamp: expiredTimestamp)
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated(){
        let store = FeedStoreSpy()
        var sut: LocalFeedLoader? = LocalFeedLoader(store: store, currentDate: Date.init)
        var receivedResults = [LocalFeedLoader.LoadResult]()
        sut?.load{ receivedResults.append($0)}
        sut = nil
        store.completeRetrievalWithEmptyCache()
        XCTAssertTrue(receivedResults.isEmpty)
    }
    // Mark: - Helpers
 
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line:UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy){
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(store, file: file, line: line)
        return (sut,store)
    }
    private func expect(_ sut: LocalFeedLoader, toCompleteWith expectedResult: LocalFeedLoader.LoadResult, when action: () -> Void){
        let exp = expectation(description: "Wait for load completion")

        sut.load{ receivedResult in
            switch (receivedResult, expectedResult){
            case let (.success(receivedImages), .success(expectedImages)):
                XCTAssertEqual(receivedImages, expectedImages)
            case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
                XCTAssertEqual(receivedError, expectedError)
            default:
                XCTFail("Expected result \(expectedResult), got \(receivedResult) instead")
            }
            exp.fulfill()
        }
        action()
        wait(for: [exp], timeout: 1.0)
    }
}
