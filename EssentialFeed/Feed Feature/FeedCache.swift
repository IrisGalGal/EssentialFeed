//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by Iris GalGal on 16/03/23.
//

import Foundation
public protocol FeedCache{
    func save(_ feed: [FeedImage]) throws
}
