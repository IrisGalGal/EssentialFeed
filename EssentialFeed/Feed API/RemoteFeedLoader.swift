//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by IrisGal on 07/08/22.
//

import Foundation
import EssentialFeed

public class RemoteFeedLoader{
    private let url : URL
    private let client : HTTPClient
    public enum Error: Swift.Error{
        case connectivity
        case invalidData
    }
    public typealias Result = Swift.Result<[FeedImage], Error>
    public init (url: URL, client: HTTPClient){
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping(Result) -> Void){
        client.get(from: url){ [weak self] result in
            guard self != nil else { return }
            switch result{
            case let .success(data, response):
                completion(RemoteFeedLoader.map(data, from: response))
            case .failure:
                completion(.failure(RemoteFeedLoader.Error.connectivity))
            }
        }
    }
    private static func map(_ data: Data, from response: HTTPURLResponse) -> Result{
        do{
            let items = try FeedItemsMapper.map(data, from: response)
            return .success(items)
        }catch{
            return .failure(error)
        }
    }
}
