//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by IrisGal on 02/11/22.
//

import Foundation
import EssentialFeed

public struct FeedImageViewModel<Image>{
    public let description : String?
    public let location : String?
    public let image: Image?
    public let isLoading: Bool
    public let shouldRetry: Bool
   
    public var hasLocation: Bool {
        return location != nil
    }
}
