//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by IrisGal on 29/07/22.
//

import Foundation

enum LoadFeedResult{
    case success([FeedItem])
    case error(Error)
}

protocol FeedLoader{
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
