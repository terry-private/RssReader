//
//  Extension_UINavigationController.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/02/17.
//

import UIKit

extension UINavigationController {
    convenience init(_ vc: UIViewController) {
        self.init(rootViewController: vc)
        navigationBar.prefersLargeTitles = true
    }
}
