//
//  XCTestCase+FailableRetrieveFeedStoreSpecs.swift
//  EssentialFeedTests
//
//  Created by IrisGal on 17/10/22.
//
import XCTest
import EssentialFeed

extension FailableRetrieveFeedStoreSpecs where Self: XCTestCase{
    func assertThatRetrieveDeliversFailureOnRetrievalError(on sut: FeedStore, file: StaticString = #file, line: UInt = #line){
        expect(sut, toRetrieve: .failure(anyNSError()), file: file, line: line)
    }
    func assertThatRetrieveDeliversHasNoSideEffectsOnFailure(on sut: FeedStore, file: StaticString = #file, line:UInt = #line){
        expect(sut, toRetrieveTwice: .failure(anyNSError()), file: file, line: line)
    }
}
