//
//  CoreDataFeedStore.swift
//  EssentialFeed
//
//  Created by IrisGal on 19/10/22.
//

import CoreData

public final class CoreDataFeedStore: FeedStore {
    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        
    }
    
    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        
    }
    
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        completion(.empty)
    }
    
    private let container : NSPersistentContainer
    
    public init(bundle: Bundle = .main) throws {
        container = try NSPersistentContainer.load(modelName: "FeedStore", in: bundle)
    }
}
private extension NSPersistentContainer{
    enum LoadingError: Swift.Error{
        case modelNotFound
        case failedToLoadPersistentStores(Swift.Error)
    }
    static func load(modelName name: String, in bundle: Bundle) throws -> NSPersistentContainer{
        guard let model = NSManagedObjectModel.with(name: name, in: bundle) else{
            throw LoadingError.modelNotFound
        }
        let container = NSPersistentContainer(name: name, managedObjectModel: model)
        var loadError: Swift.Error?
        container.loadPersistentStores { loadError = $1 }
        try loadError.map { throw LoadingError.failedToLoadPersistentStores($0)}
        return container
    }
}
private extension NSManagedObjectModel{
    static func with(name: String, in bundle: Bundle) -> NSManagedObjectModel? {
        return bundle.url(forResource: name, withExtension: "momd").flatMap{
            NSManagedObjectModel(contentsOf: $0)
        }
    }
}