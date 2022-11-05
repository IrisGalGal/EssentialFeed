//
//  MainqueueDisptachDecorator.swift
//  EssentialFeediOS
//
//  Created by IrisDarka on 05/11/22.
//

import EssentialFeed
import UIKit

final class MainqueueDisptachDecorator<T>{
    private let decorator: T
    
    init(decorator: T) {
        self.decorator = decorator
    }
    func dispatch(completion: @escaping () -> Void){
        guard Thread.isMainThread else {
            return DispatchQueue.main.async(execute: completion)
        }
        completion()
    }
}
extension MainqueueDisptachDecorator: FeedLoader where T == FeedLoader{
    func load(completion: @escaping (LoadFeedResult) -> Void) {
        decorator.load { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}
extension MainqueueDisptachDecorator: FeedImageDataLoader where T == FeedImageDataLoader{
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        decorator.loadImageData(from: url) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}
