//
//  UITableView+Dequeueing.swift
//  EssentialFeediOS
//
//  Created by IrisGal on 04/11/22.
//

import UIKit
extension UITableView{
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
