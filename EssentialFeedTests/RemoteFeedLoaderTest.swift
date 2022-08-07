//
//  RemoteFeedLoaderTest.swift
//  EssentialFeedTests
//
//  Created by IrisGal on 01/08/22.
//

import XCTest
@testable import EssentialFeed

class RemoteFeedLoader{
    let client : HTTPClient
    init (client: HTTPClient){
        self.client = client
    }
    func load(){
        client.get(from: URL(string: "https://a-url.com")!)
    }
}

protocol HTTPClient{
    func get(from url: URL)
}
class HTTPClientSpy: HTTPClient{
    func get(from url: URL) {
        requestedURL = url
    }
    var requestedURL: URL?
}
class RemoteFeedLoaderTest: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL(){
        let client = HTTPClientSpy()
        XCTAssertNil(client.requestedURL)
    }
    func test_load_requestDataFromURL(){
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(client: client)
        sut.load()
        XCTAssertNotNil(client.requestedURL)
    }
}
