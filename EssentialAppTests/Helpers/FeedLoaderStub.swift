//
//  FeedLoaderStub.swift
//  EssentialAppTests
//
//  Created by Iris GalGal on 16/03/23.
//

import EssentialFeed

public class FeedLoaderStub: FeedLoader{
    private let result: FeedLoader.Result
    
    init(result: FeedLoader.Result) {
        self.result = result
    }
    
    public func load(completion: @escaping (FeedLoader.Result) -> Void) {
        completion(result)
    }
}