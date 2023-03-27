//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by IrisGal on 02/11/22.
//

import Foundation
import EssentialFeed

public struct FeedImageViewModel<Image>{
    let description : String?
    let location : String?
    let image: Image?
    let isLoading: Bool
    let shouldRetry: Bool
   
    var hasLocation: Bool {
        return location != nil
    }
}
