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
}
