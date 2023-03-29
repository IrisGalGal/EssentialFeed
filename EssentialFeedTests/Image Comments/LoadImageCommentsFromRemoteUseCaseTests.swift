//
//  LoadImageCommentsFromRemoteUseCaseTests.swift
//  EssentialFeedAPITests
//
//  Created by Iris GalGal on 28/03/23.
//

import XCTest
import EssentialFeed

class LoadImageCommentsFromRemoteUseCaseTests: XCTestCase {
 
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
                message: "a message",
                createdAt: (date: Date(timeIntervalSince1970: 1598627222), iso8601String: "2020-08-28T15:07:02+00:00"),
                username: "username"
              )

              let item2 = makeItem(
                id: UUID(),
                message: "another message",
                createdAt: (date: Date(timeIntervalSince1970: 1598627222), iso8601String: "2020-08-28T15:07:02+00:00"),
                username: "username"
              )
            
        let items = [item1.model, item2.model]
        
        let samples = [200,201,250,280,299]

        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: .success(items), when: {
                let json = makeItemsJSON([item1.json, item2.json])
                 client.complete(withStatusCode: code, data: json, at: index)
             })
        }
            
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
    private func makeItem(id: UUID, message: String, createdAt: (date: Date, iso8601String:String), username: String) -> (model: ImageComment, json: [String: Any]){
        let item = ImageComment(id: id, message: message, createdAt: createdAt.date, username: username)
        let json: [String : Any] = [
           "id": id.uuidString,
           "message": message,
           "created_at": createdAt.iso8601String,
           "author": [
            "username": username
           ]
        ]

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
