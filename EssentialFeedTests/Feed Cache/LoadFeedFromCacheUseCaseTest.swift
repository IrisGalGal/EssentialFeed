//
//  LoadFeedFromCacheUseCaseTest.swift
//  EssentialFeedTests
//
//  Created by IrisDarka on 03/10/22.
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
    private func anyNSError() -> NSError{
        return NSError(domain: "any error", code: 0)
    }

}
