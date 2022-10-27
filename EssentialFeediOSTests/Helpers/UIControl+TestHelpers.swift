//
//  UIControl+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by IrisDarka on 27/10/22.
//

import UIKit

extension UIControl{
    func simulate(event: UIControl.Event){
        simulate(event: .valueChanged)
    }
}
