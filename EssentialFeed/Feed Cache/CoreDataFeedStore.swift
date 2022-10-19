//
//  CoreDataFeedStore.swift
//  EssentialFeed
//
//  Created by IrisGal on 19/10/22.
//

import CoreData

public final class CoreDataFeedStore: FeedStore {
    
     public init() {}
}

 private class ManagedCache: NSManagedObject {
     @NSManaged var timestamp: Date
     @NSManaged var feed: NSOrderedSet
 }

 private class ManagedFeedImage: NSManagedObject {
     @NSManaged var id: UUID
     @NSManaged var imageDescription: String?
     @NSManaged var location: String?
     @NSManaged var url: URL
     @NSManaged var cache: ManagedCache
 }
