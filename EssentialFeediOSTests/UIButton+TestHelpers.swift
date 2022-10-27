//
//  UIButton+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by IrisDarka on 27/10/22.
//

import UIKit
private extension UIButton {
     func simulateTap() {
         allTargets.forEach { target in
             actions(forTarget: target, forControlEvent: .touchUpInside)?.forEach {
                 (target as NSObject).perform(Selector($0))
             }
         }
     }
 }
