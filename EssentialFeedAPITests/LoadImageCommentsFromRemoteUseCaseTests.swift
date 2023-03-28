//
//  LoadImageCommentsFromRemoteUseCaseTests.swift
//  EssentialFeedAPITests
//
//  Created by Iris GalGal on 28/03/23.
//

import XCTest
import EssentialFeed
import EssentialFeedAPI

class LoadImageCommentsFromRemoteUseCaseTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL(){
        let (_, client) = makeSUT()
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL(){
        let (_, client) = makeSUT()
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_loadTwice_requestsDataFromURLTwice(){
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        sut.load{ _ in }
        XCTAssertEqual(client.requestedURLs, [url])
    }
    func test_load_deliversErrorOnClientError(){
        let (sut, client) = makeSUT()
        expect(sut, toCompleteWith: failure(.connectivity)) {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        }
    }
    func test_load_deliversErrorOnNon2xxHTTPResponse(){
        let (sut, client) = makeSUT()
        let samples = [199,150,300,400,500]
        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: failure(.invalidData)) {
                let json = makeItemsJSON([])
                client.complete(withStatusCode: code,data: json, at: index)
            }
        }
        
    }
    func test_load_deliversErrorOnNon2xxHTTPResponseWithInvalidJSON(){
        let (sut, client) = makeSUT()
        let samples = [200,201,250,280,299]

        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: failure(.invalidData)) {
                let invalidJSON = Data("invalid json".utf8)
                    client.complete(withStatusCode: code, data: invalidJSON, at: index)
            }
        }
        
    }
    func test_load_deliversNoItemsOn2xxHTTPResponseWithEmptyJSONList(){
        let (sut, client) = makeSUT()
        let samples = [200,201,250,280,299]

        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: .success([])) {
                let emptyListJSON = makeItemsJSON([])
                client.complete(withStatusCode: code, data: emptyListJSON, at: index)
            }
        }
        
    }
    func test_load_deliversItemsOn2xxHTTPResponseWithJSONItems() {
             let (sut, client) = makeSUT()

              let item1 = makeItem(
                id: UUID(),
                imageURL: URL(string: "http://a-url.com")!)

              let item2 = makeItem(
                 id: UUID(),
                 description: "a description",
                 location: "a location",
                 imageURL: URL(string: "http://another-url.com")!)
            
        let items = [item1.model, item2.model]
        
        let samples = [200,201,250,280,299]

        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: .success(items), when: {
                let json = makeItemsJSON([item1.json, item2.json])
                 client.complete(withStatusCode: code, data: json, at: index)
             })
        }
            
         }
    func test_load_doesNotDeliverResultAfterSUTInstanceHAsBeenDeallocated(){
        let url = URL(string: "http://a-url.com")!
        let client = HTTPClientSpy()
        var sut : RemoteImageCommentsFeedLoader? = RemoteImageCommentsFeedLoader(url: url, client: client)
        var capturedResults = [RemoteImageCommentsFeedLoader.Result]()
        sut?.load(completion: { capturedResults.append($0) })
        sut = nil
        client.complete(withStatusCode: 200, data: makeItemsJSON([]))
        XCTAssertTrue(capturedResults.isEmpty)
    }
    
    private func makeSUT(url: URL = URL(string: "https://a-given-url.com")!, file: StaticString = #filePath, line: UInt = #line) -> (sut: RemoteImageCommentsFeedLoader, client: HTTPClientSpy){
        let client = HTTPClientSpy()
        let sut = RemoteImageCommentsFeedLoader(url: url, client: client)
        trackForMemoryLeaks(sut)
        trackForMemoryLeaks(client)

        return (sut, client)
    }
    
    private func failure(_ error: RemoteImageCommentsFeedLoader.Error) -> RemoteImageCommentsFeedLoader.Result{
        return .failure(error)
    }
    private func makeItem(id: UUID, description: String? = nil, location: String? = nil, imageURL: URL) -> (model: FeedImage, json: [String: Any]){
        let item = FeedImage(id: id, description: description, location: location, url: imageURL)
        let json = [
           "id": item.id.uuidString,
           "description": item.description,
           "location": item.location,
           "image": item.url.absoluteString
        ].compactMapValues {$0}

        return (item, json)
    }
    private func makeItemsJSON(_ items: [[String: Any]]) -> Data{
        let json = ["items": items]
        return try! JSONSerialization.data(withJSONObject: json)
    }
    private func expect(_ sut: RemoteImageCommentsFeedLoader, toCompleteWith expectedResult: RemoteImageCommentsFeedLoader.Result, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line){
        
        let exp = expectation(description: "Wait for load completion")
        
        sut.load { receivedResult in
            switch (receivedResult, expectedResult){
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
            case let (.failure(receivedError as RemoteImageCommentsFeedLoader.Error), .failure(expectedError as RemoteImageCommentsFeedLoader.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        action()
        wait(for: [exp], timeout: 1.0)
    }
}

