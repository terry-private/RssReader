//
//  Extension_UIViewController.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/05/25.
//

import UIKit

extension UIViewController {
    func presentErrorAlert(title: String, message: String) {
        let alertController = AlertController()
        let dialog = Bundle.main.loadNibNamed("ErrorDialogView", owner: alertController)?.first as! ErrorDialogView
        dialog.alertController = alertController
        alertController.alertView = dialog
        dialog.set(title: title, message: message)
        present(alertController,animated: true)
    }
}
