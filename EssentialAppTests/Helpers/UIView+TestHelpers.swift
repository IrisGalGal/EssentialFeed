//
//  UIView+TestHelpers.swift
//  EssentialAppTests
//
//  Created by Iris GalGal on 22/03/23.
//

import UIKit

 extension UIView {
     func enforceLayoutCycle() {
         layoutIfNeeded()
         RunLoop.current.run(until: Date())
     }
 }
