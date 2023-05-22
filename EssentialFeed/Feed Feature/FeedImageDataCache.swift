//
//  FeedImageDataCache.swift
//  EssentialFeed
//
//  Created by Iris GalGal on 16/03/23.
//

import Foundation
public protocol FeedImageDataCache{
    func save(_ data: Data, for url: URL) throws
}
