//
//  RemoteFeedLoaderTest.swift
//  EssentialFeedTests
//
//  Created by IrisGal on 01/08/22.
//

import XCTest
@testable import EssentialFeed

class RemoteFeedLoader{
    func load(){
        HTTPClient.shared.requestedURL = URL(string: "https://a-url.com")
    }
}

class HTTPClient{
    static let shared = HTTPClient()
    private init(){}
    var requestedURL: URL?
}

class RemoteFeedLoaderTest: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL(){
        let client = HTTPClient.shared
        let sut = RemoteFeedLoader()
        XCTAssertNil(client.requestedURL)
    }
    func test_load_requestDataFromURL(){
        let client = HTTPClient.shared
        let sut = RemoteFeedLoader()
        sut.load()
        XCTAssertNil(client.requestedURL)
    }
}
