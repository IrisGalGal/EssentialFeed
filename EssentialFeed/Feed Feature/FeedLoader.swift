//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by IrisGal on 29/07/22.
//

import Foundation

public protocol FeedLoader{
    typealias LoadFeedResult = Swift.Result<[FeedImage], Error>
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
