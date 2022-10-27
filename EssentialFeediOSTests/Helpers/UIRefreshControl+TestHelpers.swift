//
//  UIRefreshControl+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by IrisDarka on 27/10/22.
//

import UIKit
extension UIRefreshControl{
    func simulatePullToRefresh(){
        allTargets.forEach { target  in
            actions(forTarget: target, forControlEvent: .valueChanged)?.forEach{
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
