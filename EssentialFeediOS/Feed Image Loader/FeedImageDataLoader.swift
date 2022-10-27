//
//  FeedImageDataLoader.swift
//  EssentialFeediOS
//
//  Created by IrisDarka on 27/10/22.
//

import UIKit
import EssentialFeed

public protocol FeedImageDataLoaderTask {
     func cancel()
}
public protocol FeedImageDataLoader {
    typealias Result = Swift.Result<Data, Error>
    func loadImageData(from url: URL, completion: @escaping (Result) -> Void) -> FeedImageDataLoaderTask
}
