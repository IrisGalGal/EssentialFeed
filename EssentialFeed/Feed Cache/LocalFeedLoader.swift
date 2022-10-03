//
//  LocalFeedLoader.swift
//  EssentialFeed
//
//  Created by IrisGal on 29/09/22.
//

import Foundation
import Metal
public final class LocalFeedLoader{
    private let store : FeedStore
    private let currentDate: () -> Date
    
    public typealias SaveResult = Error?
    
    public init(store: FeedStore,currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
    public func save(_ feed: [FeedImage], completion: @escaping (SaveResult) -> Void){
        store.deleteCachedFeed(){[weak self] error in
            guard let self = self else { return }
            
            if let cacheDeletionError = error{
                completion(cacheDeletionError)
            }else{
                self.cache(feed, with: completion)
            }
        }
    }
    public func load(completion: @escaping (Error?) -> Void ){
        store.retrieve(completion: completion)
    }
    private func cache(_ feed: [FeedImage], with completion: @escaping (SaveResult) -> Void){
        self.store.insert(feed.toLocal(), timestamp: self.currentDate()){ [weak self] error in
            guard self != nil else { return }
            completion(error)
        }
    }
}
private extension Array where Element == FeedImage{
    func toLocal() -> [LocalFeedImage]{
        return map { LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url) }
    }
}