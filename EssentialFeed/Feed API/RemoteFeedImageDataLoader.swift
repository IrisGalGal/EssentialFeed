//
//  RemoteFeedImageDataLoader.swift
//  EssentialFeed
//
//  Created by IrisGal on 15/02/23.
//

import Foundation

public final class RemoteFeedImageDataLoader: FeedImageDataLoader{
    private let client: HTTPClient
    
    init(client: HTTPClient){
        self.client = client
    }
    
    public enum Error: Swift.Error{
        case invalidData
        case connectivity
    }
    
    private final class HTTPClientTaskWrapper: FeedImageDataLoaderTask {
        
        private var completion: ((FeedImageDataLoader.Result) -> Void)?
        
        var wrapped: HTTPClientTask?
        
        init(_ completion: @escaping (FeedImageDataLoader.Result) -> Void) {
            self.completion = completion
        }
        
        func complete(with result: FeedImageDataLoader.Result){
            completion?(result)
        }
        
        func cancel() {
            self.preventFurtherCompletions()
            wrapped?.cancel()
        }
        
        private func preventFurtherCompletions(){
            completion = nil
        }
    }
    
    public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        var task = HTTPClientTaskWrapper(completion)
        task.wrapped = client.get(from: url) { [weak self] result in
            guard self != nil else { return }

            task.complete(with: result
                .mapError { _ in Error.connectivity }
                .flatMap { (data, response) in
                    let isValidResponse = response.statusCode == 200 && !data.isEmpty
                    return isValidResponse ? .success(data) : .failure(Error.invalidData)
            })
        }
        return task
    }
}