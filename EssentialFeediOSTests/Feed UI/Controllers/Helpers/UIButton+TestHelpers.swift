//
//  UIButton+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by IrisDarka on 27/10/22.
//

import UIKit
extension UIButton {
     func simulateTap() {
         simulate(event: .touchUpInside)
     }
 }
