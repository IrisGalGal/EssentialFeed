//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by IrisDarka on 29/09/22.
//

import Foundation
struct RemoteFeedItem: Decodable{
    let id : UUID
    let description: String?
    let location: String?
    let image: URL
    
}
