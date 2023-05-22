//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by IrisDarka on 01/03/23.
//

import Foundation

public protocol FeedImageDataStore {
    func insert(_ data: Data, for url: URL) throws
    func retrieve(dataForURL url: URL) throws -> Data?
}
