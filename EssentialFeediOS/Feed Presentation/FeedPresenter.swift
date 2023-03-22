//
//  FeedPresenter.swift
//  EssentialFeediOS
//
//  Created by IrisGal on 02/11/22.
//
import Foundation
import EssentialFeed


protocol FeedLoadingView{
    func display(_ viewModel: FeedLoadingViewModel)
}

protocol FeedView{
    func display(_ viewModel: FeedViewModel)
}
protocol FeedErrorView {
    func display(_ viewModel: FeedErrorModel)
}
public final class FeedPresenter{
    private let feedView: FeedView
    private let loadingView: FeedLoadingView
    private let errorView: FeedErrorView

    init(feedView: FeedView, loadingView: FeedLoadingView, errorView: FeedErrorView) {
        self.feedView = feedView
        self.loadingView = loadingView
        self.errorView = errorView
    }
    public static var title: String{
        return NSLocalizedString("FEED_VIEW_TITLE", tableName: "Feed", bundle: Bundle(for: FeedPresenter.self), comment: "Title for the feed view")
    }
    public static var errorTitle: String{
        return NSLocalizedString("FEED_VIEW_CONNECTION_ERROR", tableName: "Feed", bundle: Bundle(for: FeedPresenter.self), comment: "Error message displayed when we can't load the image feed from the server")
    }
    public func didStartLoadingFeed() {
        errorView.display(FeedErrorModel(message: nil))
        loadingView.display(FeedLoadingViewModel(isLoading: true))
    }

    public func didFinishLoadingFeed(with feed: [FeedImage]) {
        feedView.display(FeedViewModel(feed: feed))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }

    public func didFinishLoadingFeed(with error: Error) {
        loadingView.display(FeedLoadingViewModel(isLoading: false))
        errorView.display(FeedErrorModel(message: FeedPresenter.errorTitle))
    }

}
