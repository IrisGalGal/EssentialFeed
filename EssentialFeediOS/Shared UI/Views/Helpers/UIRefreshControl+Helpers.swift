//
//  UIRefreshControl+Helpers.swift
//  EssentialFeediOS
//
//  Created by Iris GalGal on 5/22/23.
//

import UIKit

extension UIRefreshControl {
    func update(isRefreshing: Bool) {
        isRefreshing ? beginRefreshing() : endRefreshing()
    }
}
