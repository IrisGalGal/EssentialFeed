//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by IrisGal on 29/07/22.
//

import Foundation

public struct FeedItem: Equatable{
    let id : UUID
    var description: String?
    var location: String?
    var imageURL: URL
}
