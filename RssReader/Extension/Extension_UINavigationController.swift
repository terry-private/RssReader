//
//  Extension_UINavigationController.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/02/17.
//

import UIKit

extension UINavigationController {
    convenience init(_ vc: UIViewController, prefersLargeTitles: Bool = true) {
        self.init(rootViewController: vc)
        navigationBar.prefersLargeTitles = prefersLargeTitles
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor(named: "MainLabel")!]
        navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor(named: "MainLabel")!]
    }
}
