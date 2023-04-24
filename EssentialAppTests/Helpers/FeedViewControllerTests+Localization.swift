//
//  FeedViewControllerTests+Localization.swift
//  EssentialFeediOSTests
//
//  Created by IrisDarka on 04/11/22.
//

import Foundation
import XCTest
import EssentialFeed
import EssentialFeediOS

extension FeedUIIntegrationTest {
    private class DummyView: ResourceView{
        typealias ResourceViewModel = String

        func display(_ viewModel: String) {
        }
    }
    var loadError: String{
        LoadResourcePresenter<Any, DummyView>.loadError
    }
    var feedTitle: String{
        FeedPresenter.title
    }
    var commentsTitle: String{
        ImageCommentsPresenter.title
    }
}
