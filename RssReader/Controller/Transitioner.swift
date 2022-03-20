//
//  Transitioner.swift
//  RssReader
//
//  Created by 若江照仁 on 2020/12/23.
//

import Foundation
import UIKit

protocol Transitioner {
    func pushViewController(_ viewController: UIViewController, animated: Bool)
    func popViewController(animated: Bool)
    func popToRootViewController(animated: Bool)
    func popToViewController(_ viewController: UIViewController, animated: Bool)
    func present(_ viewController: UIViewController,
                 animated: Bool,
                 completion: (() -> ())?)
    func dismiss(animated: Bool)
}

extension Transitioner  where Self: UIViewController {
    func pushViewController(_ viewController: UIViewController,
                            animated: Bool) {
        guard let nc = navigationController else { return }
        // FIXME: ↑は強制アンラップで落としてあげた方が良いかもしれない？
        nc.pushViewController(viewController, animated: animated)
    }

    func popViewController(animated: Bool) {

    }

    func popToRootViewController(animated: Bool) {
    }

    func popToViewController(_ viewController: UIViewController, animated: Bool) {
    }

    func present(_ viewController: UIViewController, animated: Bool, completion: (() -> ())? = nil) {
        print("Transitioner>present")
        present(viewController, animated: animated, completion: completion)
    }

    func dismiss(animated: Bool) {
        dismiss(animated: animated)
    }
}
