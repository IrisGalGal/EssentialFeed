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

        let presentationAdapter = FeedLoaderPresentationAdapter(
            feedLoader: MainqueueDisptachDecorator(decorator: loader))
        
        let feedController = FeedViewController.makeWith(delegate: presentationAdapter, title: FeedPresenter.title)
        presentationAdapter.presenter = FeedPresenter(
            feedView: FeedViewAdapter(
                controller: feedController,
                imageLoader: MainqueueDisptachDecorator(decorator: imageLoader)),
            loadingView: WeakRefVirtualProxy(feedController))
        
        return feedController
    }
}
private extension FeedViewController{
    static func makeWith(delegate: FeedViewControllerDelegate, title: String) -> FeedViewController{
        let bundle = Bundle(for: FeedViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let feedController = storyboard.instantiateInitialViewController() as! FeedViewController
        feedController.delegate = delegate
        feedController.title = FeedPresenter.title
        return feedController
    }
}
