//
//  FeedViewController+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by IrisDarka on 27/10/22.
//

import UIKit
import EssentialFeediOS

extension FeedViewController {
    func simulateUserInitiatedFeedReload() {
        refreshControl?.simulatePullToRefresh()
    }
   var isShowingLoadingIndicator: Bool {
       return refreshControl?.isRefreshing == true
   }
   @discardableResult
    func simulateFeedImageViewVisible(at index: Int) -> FeedImageCell? {
        return feedImageView(at: index) as? FeedImageCell
    }
    @discardableResult
    func simulateFeedImageViewNotVisible(at row: Int) -> FeedImageCell? {
        let view = simulateFeedImageViewVisible(at: row)

        let delegate = tableView.delegate
        let index = IndexPath(row: row, section: feedImagesSection)
        delegate?.tableView?(tableView, didEndDisplaying: view!, forRowAt: index)
        
        return view
    }
   func numberOfRenderedFeedImageViews() -> Int {
       return tableView.numberOfRows(inSection: feedImagesSection)
   }

   func feedImageView(at row: Int) -> UITableViewCell? {
       let ds = tableView.dataSource
       let index = IndexPath(row: row, section: feedImagesSection)
       return ds?.tableView(tableView, cellForRowAt: index)
   }

   private var feedImagesSection: Int {
       return 0
   }
   func simulateFeedImageViewNearVisible(at row: Int) {
       let ds = tableView.prefetchDataSource
       let index = IndexPath(row: row, section: feedImagesSection)
       ds?.tableView(tableView, prefetchRowsAt: [index])
   }
   func simulateFeedImageViewNotNearVisible(at row: Int) {
       simulateFeedImageViewNearVisible(at: row)

       let ds = tableView.prefetchDataSource
       let index = IndexPath(row: row, section: feedImagesSection)
       ds?.tableView?(tableView, cancelPrefetchingForRowsAt: [index])
   }
 }
