//
//  RemoteFeedLoaderTest.swift
//  EssentialFeedTests
//
//  Created by IrisGal on 01/08/22.
//

import XCTest
import EssentialFeed

class RemoteFeedLoaderTest: XCTestCase {
    
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
        expect(sut, toCompleteWith: .failure(.connectivity)) {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        }
    }
    func test_load_deliversErrorOnNon200HTTPResponse(){
        let (sut, client) = makeSUT()
        let samples = [199,201,300,400,500]
        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: .failure(.invalidData)) {
                client.complete(withStatusCode: 400, at: index)
            }
        }
        
    }
    func test_load_deliversErrorOnNon200HTTPResponseWithInvalidJSON(){
        let (sut, client) = makeSUT()
        expect(sut, toCompleteWith: .failure(.invalidData)) {
            let invalidJSON = Data("invalid json".utf8)
                client.complete(withStatusCode: 200, data: invalidJSON)
        }
    }
    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyJSONList(){
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .success([])) {
            let emptyListJSON = Data(bytes: "{\"items\":[]}".utf8)
            client.complete(withStatusCode: 200, data: emptyListJSON)
        }
    }
    private func makeSUT(url: URL = URL(string: "https://a-given-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy){
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        
        return (sut, client)
    }
    private func expect(_ sut: RemoteFeedLoader, toCompleteWith result: RemoteFeedLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line){
        var capturedErrors = [RemoteFeedLoader.Result]()
        sut.load {capturedErrors.append($0)}
        action()
        XCTAssertEqual(capturedErrors, [result], file: file,line: line)
    }
}
private class HTTPClientSpy: HTTPClient{
    private var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()

    var requestedURLs : [URL]{
        return messages.map{ $0.url}
    }
    var completions = [(Error)-> Void]()
    
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
        messages.append((url, completion))
    }
    func complete(with error:Error, at index: Int = 0){
        messages[index].completion(.failure(error))
    }
    func complete(withStatusCode code:Int,data: Data = Data(), at index: Int = 0){
        let response = HTTPURLResponse(url: requestedURLs[index],
                                       statusCode: code,
                                       httpVersion: nil,
                                       headerFields: nil)!
        messages[index].completion(.success(data, response))
    }
}
