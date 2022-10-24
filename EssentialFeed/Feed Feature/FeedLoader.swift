//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by IrisGal on 29/07/22.
//

import Foundation
import AppKit

public typealias LoadFeedResult = Result<[FeedImage], Error>

public protocol FeedLoader{
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
