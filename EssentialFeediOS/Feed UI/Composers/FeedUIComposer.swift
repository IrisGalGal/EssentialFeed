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
        let presenter = FeedPresenter(feedLoader: loader)
        let feedViewModel = FeedViewModel(feedLoader: loader)
        let refreshController = FeedRefreshViewController(presenter: presenter)
        let feedController = FeedViewController(refreshController: refreshController)
        presenter.loadingView = WeakRefVirtualProxy(refreshController)
        presenter.feedView = FeedViewAdapter(controller: feedController, imageLoader: imageLoader)
        return feedController
    }
}
private final class WeakRefVirtualProxy <T: AnyObject>{
    private weak var object: T?
    
    init(_ object: T){
        self.object = object
    }
}

extension WeakRefVirtualProxy: FeedLoadingView where T: FeedLoadingView{
    func display(isLoading: Bool) {
        object?.display(isLoading: isLoading)
    }
}
private final class FeedViewAdapter: FeedView{
    private weak var controller : FeedViewController?
    private let imageLoader: FeedImageDataLoader
    
    init(controller: FeedViewController, imageLoader: FeedImageDataLoader){
        self.controller = controller
        self.imageLoader = imageLoader
    }
    
    func display(feed: [FeedImage]) {
        controller?.tableModel = feed.map{ model in
            FeedImageCellController(viewModel: FeedImageViewModel(model: model, imageLoader: imageLoader, imageTransformer: UIImage.init))
        }
    }
}
