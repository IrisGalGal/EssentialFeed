//
//  LoadResourcePresenter.swift
//  EssentialFeed
//
//  Created by Iris GalGal on 30/03/23.
//

import Foundation
public protocol ResourceView{
    associatedtype ResourceViewModel
    func display(_ viewModel: String)
}
public final class LoadResourcePresenter<Resource, View: ResourceView>{
    public typealias Mapper = (Resource) -> String

    private let resourceView: View
    private let loadingView: FeedLoadingView
    private let errorView: FeedErrorView
    private let mapper: Mapper

    public init(resourceView: View, loadingView: FeedLoadingView, errorView: FeedErrorView, mapper: @escaping Mapper) {
        self.resourceView = resourceView
        self.loadingView = loadingView
        self.errorView = errorView
        self.mapper = mapper
    }
    
    public static var errorTitle: String{
        return NSLocalizedString("GENERIC_CONNECTION_ERROR", tableName: "Feed", bundle: Bundle(for: FeedPresenter.self), comment: "Error message displayed when we can't load the image feed from the server")
    }
    public func didStartLoading() {
        errorView.display(FeedErrorViewModel(message: nil))
        loadingView.display(FeedLoadingViewModel(isLoading: true))
    }

    public func didFinishLoading(with resource: Resource) {
        resourceView.display(mapper(resource))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }

    public func didFinishLoading(with error: Error) {
        loadingView.display(FeedLoadingViewModel(isLoading: false))
        errorView.display(FeedErrorViewModel(message: FeedPresenter.errorTitle))
    }

}
