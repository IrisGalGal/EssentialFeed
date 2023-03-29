//
//  RemoteImageCommentsFeedLoader.swift
//  EssentialFeedAPI
//
//  Created by Iris GalGal on 28/03/23.
//

import EssentialFeed

public typealias RemoteImageCommentsFeedLoader = RemoteLoader<[ImageComment]>

public extension RemoteImageCommentsFeedLoader{
    convenience init(url: URL, client: HTTPClient) {
        self.init(url:url, client: client, mapper: ImageCommentsMapper.map)
    }
}
