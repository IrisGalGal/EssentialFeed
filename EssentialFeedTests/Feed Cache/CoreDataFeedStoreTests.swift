//
//  CoreDataFeedStoreTests.swift
//  EssentialFeedTests
//
//  Created by IrisGal on 18/10/22.
//

import XCTest
import EssentialFeed

class CoreDataFeedStoreTests: XCTestCase, FeedStoreSpecs {
    
    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = makeSUT()
        assertThatRetrieveDeliversEmptyOnEmptyCache(on: sut)
    }
    
    func test_retrieve_hasNoSideEffects() {
        let sut = makeSUT()
        assertThatRetrieveHasNoSideEffectsOnEmptyCache(on: sut)
    }
    
    func test_retrieve_deliversFoundValuesOnNonEmptyCache() {
            
    }
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {
            
    }
    
    func test_insert_deliversNoErrorOnEmptyCache() {
            
    }
    
    func test_insert_deliversNoErrorNonEmptyCache() {
            
    }
    
    func test_insert_overridesPreviuslyInsertedCacheValues() {
            
    }
    
    func test_delete_deliversNoErrorOnEmptyCache() {
            
    }
    
    func test_delete_hasNoSideEffectsOnEmptyCache() {
            
    }
    
    func test_delete_deliversNoErrorOnNonEmptyCache() {
            
    }
    
    func test_delete_emptiesPreviouslyInsertedCache() {
            
    }
    
    func test_storeSideEffects_runSerially() {
            
    }
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> FeedStore{
        let sut = CoreFataFeedStore()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
