//
//  XCTestCase+FialableInsertFeedStoreSpecs.swift
//  EssentialFeedTests
//
//  Created by IrisGal on 17/10/22.
//

import XCTest
import EssentialFeed

extension FailableInsertFeedStoreSpecs where Self: XCTestCase{
    func assertThatInsertDeliversErrorOnInsertionError(on sut: FeedStore, file: StaticString = #file, line: UInt = #line){
        let insertionError = insert((uniqueImageFeed().local, Date()), to: sut)
        XCTAssertNotNil(insertionError, "Expected cache insertion to fail with an error")

    }
    func assertThatInsertHasNoSideEffectsOnInsertionError(on sut: FeedStore, file: StaticString = #file, line: UInt = #line){
        insert((uniqueImageFeed().local, Date()), to: sut)
        expect(sut, toRetrieveTwice: .success(.none), file: file, line: line)
    }
}
