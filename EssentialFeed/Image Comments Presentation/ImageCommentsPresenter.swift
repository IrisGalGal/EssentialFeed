//
//  ImageCommentsPresenter.swift
//  EssentialFeed
//
//  Created by Iris GalGal on 12/04/23.
//

import Foundation
import Foundation

public final class ImageCommentsPresenter{
   
    public static var title: String{
        return NSLocalizedString("IMAGE_COMMENTS_VIEW_TITLE", tableName: "ImageComments", bundle: Bundle(for: Self.self), comment: "Title for the image comments view")
    }
    public static func map(_ feed: [FeedImage]) -> FeedViewModel{
        FeedViewModel(feed: feed)
    }
}
