//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by IrisGal on 02/11/22.
//

import Foundation
import EssentialFeed

public struct FeedImageViewModel{
    public let description : String?
    public let location : String?
   
    public var hasLocation: Bool {
        return location != nil
    }
}
