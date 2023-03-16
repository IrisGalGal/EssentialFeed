//
//  FeedImageDataLoaderWithFallbackComposite.swift
//  EssentialApp
//
//  Created by IrisDarka on 08/03/23.
//

import EssentialFeed

public class FeedImageDataLoaderWithFallbackComposite: FeedImageDataLoader{
    private let primary: FeedImageDataLoader
    private let fallback: FeedImageDataLoader
    
    public init(primary: FeedImageDataLoader, fallback: FeedImageDataLoader) {
        self.primary = primary
        self.fallback = fallback
    }

    private class TaskWrapper: FeedImageDataLoaderTask{
        var wrapped: FeedImageDataLoaderTask?
        func cancel() {
            wrapped?.cancel()
        }
    }
    public func loadImageData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) -> FeedImageDataLoaderTask {
        let task = TaskWrapper()
        task.wrapped = primary.loadImageData(from: url, completion: { [weak self] result in
            switch result{
            case .success:
                completion(result)
            case .failure:
                task.wrapped = self?.fallback.loadImageData(from: url, completion: completion)
            }
        })
        return task
    }
}
