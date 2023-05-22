//
//  FeedImageCell.swift
//  EssentialFeediOSTests
//
//  Created by IrisDarka on 27/10/22.
//

import UIKit
import EssentialFeediOS

extension FeedImageCell{
    var isShowingLocation: Bool {
        return !locationContainer.isHidden
    }
    var isShowingRetryAction: Bool {
        return !feedImageRetryButton.isHidden
    }
    var locationText: String? {
        return locationLabel.text
    }

    var descriptionText: String? {
        return descriptionLabel.text
    }
    
    var isShowingImageLoadingIndicator: Bool{
        return feedImageContainer.isShimmering
    }
    var renderedImage: Data? {
        return feedImageView.image?.pngData()
    }
    func simulateRetryAction() {
        feedImageRetryButton.simulateTap()
    }
    
}
