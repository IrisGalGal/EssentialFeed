//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by IrisDarka on 01/03/23.
//

import Foundation
protocol FeedImageDataStore {
    typealias Result = Swift.Result<Data?, Error>

    func retrieve(dataForURL url: URL, completion: @escaping (Result) -> Void)
}
