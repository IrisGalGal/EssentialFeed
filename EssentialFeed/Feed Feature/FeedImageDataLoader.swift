//
//  FeedImageDataLoader.swift
//  EssentialFeed
//
//  Created by IrisGal on 15/02/23.
//

import Foundation

public protocol FeedImageDataLoader{
    func loadImageData(from url: URL) throws -> Data
}
