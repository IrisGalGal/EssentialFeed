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
        let exp = expectation(description: "Wait for load completion")
        var receivedError : Error?
        sut.load{ result in
            switch result{
            case let .failure(error):
                receivedError = error
            default:
                XCTFail("Expected failure, got \(result) instead")
            }
            exp.fulfill()
        }
        store.completeRetrieval(with: retrievalError)
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(receivedError as NSError?, retrievalError)
    }
    // Mark: - Helpers
 
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line:UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy){
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(store, file: file, line: line)
        return (sut,store)
    }
    private func anyNSError() -> NSError{
        return NSError(domain: "any error", code: 0)
    }

}
