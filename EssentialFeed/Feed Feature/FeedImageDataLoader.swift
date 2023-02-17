//
//  FeedImageDataLoader.swift
//  EssentialFeed
//
//  Created by IrisGal on 15/02/23.
//

import Foundation
public protocol FeedImageDataLoaderTask{
    func cancel()
}

public protocol FeedImageDataLoader{
    typealias Result = Swift.Result<Data, Error>
    
    func loadImageData(from url: URL, completion: @escaping (Result) -> Void) -> FeedImageDataLoader
}
