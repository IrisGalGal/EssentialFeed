//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by IrisGal on 29/09/22.
//

import Foundation
public struct RemoteFeedItem: Decodable{
    let id : UUID
    let description: String?
    let location: String?
    let image: URL
    
}
