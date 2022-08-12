//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by IrisGal on 07/08/22.
//

import Foundation

public protocol HTTPClient{
    func get(from url: URL)
}

public class RemoteFeedLoader{
    private let url : URL
    private let client : HTTPClient
    
    public init (url: URL, client: HTTPClient){
        self.url = url
        self.client = client
    }
    
    public func load(){
        client.get(from: url)
    }
}
