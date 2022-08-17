//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by IrisGal on 29/07/22.
//

import Foundation
import AppKit

public enum LoadFeedResult<Error: Swift.Error>{
    case success([FeedItem])
    case failure(Error)
}

protocol FeedLoader{
    associatedtype Error: Swift.Error
    func load(completion: @escaping (LoadFeedResult<Error>) -> Void)
}
