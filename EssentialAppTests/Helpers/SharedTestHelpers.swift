//
//  SharedTestHelpers.swift
//  EssentialAppTests
//
//  Created by Iris GalGal on 16/03/23.
//

import EssentialFeed

func uniqueFeed() -> [FeedImage]{
    return [FeedImage(id: UUID(), description: "any", location: "any", url: anyURL())]
}
func anyURL() -> URL{
    return URL(string: "http://any-url.com")!
}
func anyNSError() -> NSError{
    return NSError(domain: "any error", code: 0)
}
func anyData() -> Data{
    return Data("any data".utf8)
}
private class DummyView: ResourceView {
    func display(_ viewModel: Any) {}
}

var loadError: String {
    LoadResourcePresenter<Any, DummyView>.loadError
}
var commentsTitle: String{
    ImageCommentsPresenter.title
}
