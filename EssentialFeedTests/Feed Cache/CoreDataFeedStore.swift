//
//  CoreDataFeedStore.swift
//  EssentialFeedTests
//
//  Created by IrisGal on 18/10/22.
//

import Foundation
@testable import EssentialFeed

public final class CoreFataFeedStore: FeedStore{
    public init(){
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion){
        completion(.empty)
        
    }
    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        
    }
    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        
    }
}
