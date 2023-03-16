//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by Iris GalGal on 16/03/23.
//

import Foundation
public protocol FeedCache{
    typealias Result = Swift.Result<Void, Error>
    func save(_ feed: [FeedImage], completion: @escaping (Result) -> Void)
}
