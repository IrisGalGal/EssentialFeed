//
//  ImageCommentsMapper.swift
//  EssentialFeedAPI
//
//  Created by Iris GalGal on 28/03/23.
//

import Foundation

internal final class ImageCommentsMapper{
    private struct Root: Decodable{
        let items : [RemoteFeedItem]
    }
    
    
    internal static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteFeedItem]{
        guard response.isOK, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteImageCommentsFeedLoader.Error.invalidData
        }
        return root.items
    }
}
