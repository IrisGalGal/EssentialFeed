//
//  CodableFeedStoreTests.swift
//  EssentialFeedTests
//
//  Created by IrisGal on 10/10/22.
//

import Foundation
import XCTest
import EssentialFeed
class CodableFeedStore{
    func retrieve(completion: @escaping FeedStore.RetrievalCompletion){
        completion(.empty)
    }
}
class CodableFeedStoreTests: XCTestCase{
    func test_retrieve_deliversEmptyOnEmptyCache(){
        let sut = CodableFeedStore()
        let exp = expectation(description: "Wait for cache retrieval")
        sut.retrieve { result in
            switch result{
            case .empty:
                break
            default:
                XCTFail("Expected empty result, got \(result)")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    func test_retrieve_hasNoSideEffects(){
        let sut = CodableFeedStore()
        let exp = expectation(description: "Wait for cache retrieval")
        sut.retrieve { firstResult in
            sut.retrieve { secondResult in
                switch (firstResult, secondResult){
                case (.empty,.empty):
                    break
                default:
                    XCTFail("Expected retrieving twice from empty cache to deliver same empty reuslt, got \(firstResult) and \(secondResult) instead")
                }
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 1.0)
    }
}
