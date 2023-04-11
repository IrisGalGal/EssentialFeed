//
//  FeedPresenter.swift
//  EssentialFeediOS
//
//  Created by IrisGal on 02/11/22.
//
import Foundation

public protocol FeedView{
    func display(_ viewModel: FeedViewModel)
}
public protocol FeedErrorView {
    func display(_ viewModel: FeedErrorViewModel)
}
public final class FeedPresenter{
    private let feedView: FeedView
    private let loadingView: ResourceLoadingView
    private let errorView: FeedErrorView

    public init(feedView: FeedView, loadingView: ResourceLoadingView, errorView: FeedErrorView) {
        self.feedView = feedView
        self.loadingView = loadingView
        self.errorView = errorView
    }
    public static var title: String{
        return NSLocalizedString("FEED_VIEW_TITLE", tableName: "Feed", bundle: Bundle(for: FeedPresenter.self), comment: "Title for the feed view")
    }
    public static var errorTitle: String{
        return NSLocalizedString("GENERIC_CONNECTION_ERROR", tableName: "Feed", bundle: Bundle(for: FeedPresenter.self), comment: "Error message displayed when we can't load the image feed from the server")
    }
    public func didStartLoadingFeed() {
        errorView.display(FeedErrorViewModel(message: nil))
        loadingView.display(ResourceLoadingViewModel(isLoading: true))
    }

    public func didFinishLoadingFeed(with feed: [FeedImage]) {
        feedView.display(FeedViewModel(feed: feed))
        loadingView.display(ResourceLoadingViewModel(isLoading: false))
    }

    public func didFinishLoadingFeed(with error: Error) {
        loadingView.display(ResourceLoadingViewModel(isLoading: false))
        errorView.display(FeedErrorViewModel(message: FeedPresenter.errorTitle))
    }

}
