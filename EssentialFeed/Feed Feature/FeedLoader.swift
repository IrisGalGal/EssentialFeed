//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by IrisGal on 29/07/22.
//

import Foundation
import AppKit

public enum LoadFeedResult{
    case success([FeedItem])
    case failure(Error)
}

protocol FeedLoader{
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
