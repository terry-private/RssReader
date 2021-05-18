//
//  Extension_UITableViewCell.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/05/18.
//

import UIKit

extension UITableViewCell {

    @IBInspectable
    var selectedBackgroundColor: UIColor? {
        get {
            return selectedBackgroundView?.backgroundColor
        }
        set(color) {
            let background = UIView()
            background.backgroundColor = color
            selectedBackgroundView = background
        }
    }

}
