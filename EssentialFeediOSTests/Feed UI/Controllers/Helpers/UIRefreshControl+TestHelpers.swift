//
//  UIRefreshControl+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by IrisDarka on 27/10/22.
//

import UIKit
extension UIRefreshControl{
    func simulatePullToRefresh(){
        simulate(event: .valueChanged)
    }
}
