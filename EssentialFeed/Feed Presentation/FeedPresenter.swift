//
//  FeedPresenter.swift
//  EssentialFeediOS
//
//  Created by IrisGal on 02/11/22.
//
import Foundation

public final class FeedPresenter{
   
    public static var title: String{
        return NSLocalizedString("FEED_VIEW_TITLE", tableName: "Feed", bundle: Bundle(for: FeedPresenter.self), comment: "Title for the feed view")
    }
}
