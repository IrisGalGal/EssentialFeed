//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by IrisDarka on 27/10/22.
//

import UIKit
import EssentialFeed

public final class FeedUIComposer{
    public static func feedComposedWith(loader: FeedLoader, imageLoader: FeedImageDataLoader) -> FeedViewController{
        let feedViewModel = FeedViewModel(feedLoader: loader)
        let refreshController = FeedRefreshViewController(viewModel: feedViewModel)
        let feedController = FeedViewController(refreshController: refreshController)
        feedViewModel.onFeedLoad = adaptFeedToCellControllers(forwardingTo: feedController, loader: imageLoader)
        return feedController
    }
    private static func adaptFeedToCellControllers(forwardingTo controller: FeedViewController, loader: FeedImageDataLoader) -> ([FeedImage]) -> Void{
        return { [weak controller] feed in
            controller?.tableModel = feed.map{ model in
                FeedImageCellController(viewModel: FeedImageViewModel(model: model, imageLoader: loader))
            }
        }
    }
}
