//
//  CacheFeedUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by IrisGal on 28/09/22.
//

import Foundation
import XCTest
import EssentialFeed

class CacheFeedUseCaseTests: XCTestCase{
    func test_init_doesNotMessageStoreUponCreation(){
        let (_,store) = makeSUT()

        XCTAssertEqual(store.receivedMessages, [])
    }
    func test_save_requestsCacheDeletion(){
        let feed = [uniqueImage(),uniqueImage()]
        let (sut,store) = makeSUT()
        sut.save(feed) { _ in }
        XCTAssertEqual(store.receivedMessages, [.deleteCachedFeed])
    }
    func test_save_doesRequestCacheInsertionOnDeletionError(){
        let (sut,store) = makeSUT()
        let deletionError = anyNSError()
        sut.save(uniqueImageFeed().models) { _ in }
        store.completeDeletion(with: deletionError)
        XCTAssertEqual(store.receivedMessages, [.deleteCachedFeed])
    }
    func test_save_requestsNewCacheInsertionWithTimestampOnSuccessfulDeletion(){
        let timestamp = Date()
        let feed = uniqueImageFeed()
        let (sut,store) = makeSUT(currentDate: {timestamp})
        
        sut.save(feed.models) { _ in }
        store.completeDeletionSuccessfully()
        XCTAssertEqual(store.receivedMessages, [.deleteCachedFeed, .insert(feed.local, timestamp)])
    }
    func test_save_failsOnDeletionError(){
        let (sut,store) = makeSUT()
        let deletionError = anyNSError()
        
        expect(sut, toCompleteWithError: deletionError) {
            store.completeDeletion(with: deletionError)

        }
    }
    
    func test_save_failsOnInsertionError(){
        let (sut,store) = makeSUT()
        let insertionError = anyNSError()
        
        expect(sut, toCompleteWithError: insertionError) {
            store.completeDeletionSuccessfully()
            store.completeInsertion(with: insertionError)
        }
    }
    func test_save_succeedsOnsuccessfulCacheInsertion(){
        let (sut,store) = makeSUT()
       
        expect(sut, toCompleteWithError: nil) {
            store.completeDeletionSuccessfully()
            store.completeInsertionSuccessfully()
        }
    }
    
    func test_save_doesNotDeliverDeletionErrorAfterSUTInstanceHasBeenDeallocated(){
        let store = FeedStoreSpy()
        var sut : LocalFeedLoader? = LocalFeedLoader(store: store, currentDate: Date.init)
        
        var receivedResults = [LocalFeedLoader.SaveResult] ()
        sut?.save(uniqueImageFeed().models){ receivedResults.append($0)}
        
        sut = nil
        store.completeDeletion(with: anyNSError())
        XCTAssertTrue(receivedResults.isEmpty)
    }
    
    func test_save_doesNotDeliverInsertionErrorAfterSUTInstanceHasBeenDeallocated(){
        let store = FeedStoreSpy()
        var sut : LocalFeedLoader? = LocalFeedLoader(store: store, currentDate: Date.init)
        
        var receivedResults = [LocalFeedLoader.SaveResult] ()
        sut?.save(uniqueImageFeed().models){ receivedResults.append($0)}
        
        store.completeDeletionSuccessfully()
        sut = nil
        store.completeInsertion(with: anyNSError())
        XCTAssertTrue(receivedResults.isEmpty)
    }
    // Mark: - Helpers
    private func expect(_ sut: LocalFeedLoader, toCompleteWithError expectedError: NSError?, when action: () -> Void, file: StaticString = #file, line:UInt = #line){
        let exp = expectation(description: "Wait for save completion")
        
        var receivedError: Error?
        sut.save(uniqueImageFeed().models){error in
            receivedError = error
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(receivedError as NSError?, expectedError, file: file, line: line)
    }
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line:UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy){
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(store, file: file, line: line)
        return (sut,store)
    }
    private class FeedStoreSpy: FeedStore{
        enum ReceivedMessage: Equatable{
            case deleteCachedFeed
            case insert([LocalFeedImage], Date)
        }
        private(set) var receivedMessages = [ReceivedMessage]()
        
        private var deletionCompletions = [DeletionCompletion]()
        private var insertionCompletions = [InsertionCompletion]()
        
        func deleteCachedFeed(completion: @escaping DeletionCompletion){
            deletionCompletions.append(completion)
            receivedMessages.append(.deleteCachedFeed)
        }
        func completeDeletion(with error: Error, at index: Int = 0){
            deletionCompletions[index](error)
        }
        func completeDeletionSuccessfully(at index: Int = 0){
            deletionCompletions[index](nil)
        }
        func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion){
            insertionCompletions.append(completion)
            receivedMessages.append(.insert(feed, timestamp))
        }
        func completeInsertion(with error: Error, at index: Int = 0){
            insertionCompletions[index](error)
        }
        func completeInsertionSuccessfully(at index: Int = 0){
            insertionCompletions[index](nil)
        }
    }

    private func uniqueImage() -> FeedImage{
        return FeedImage(id: UUID(), description: "any", location: "any", url: anyURL())
    }
    private func uniqueImageFeed() -> (models:[FeedImage], local:[LocalFeedImage]){
        let models = [uniqueImage(),uniqueImage()]
        let local = models.map { LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url)}
        return (models, local)
    }
    private func anyURL() -> URL{
        return URL(string: "http://any-url.com")!
    }
    private func anyNSError() -> NSError{
        return NSError(domain: "any error", code: 0)
    }
}
