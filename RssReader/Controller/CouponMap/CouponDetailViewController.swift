//
//  CouponDetailViewController.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/06/01.
//

import UIKit
import WebKit

class CouponDetailViewController: UIViewController, Transitioner {
    @IBOutlet weak var webView: WKWebView!
    var restaurant: Restaurant?
    override func viewDidLoad() {
        super.viewDidLoad()
        let closeButton = UIBarButtonItem(title: LStrings.close.value, style: .plain, target: self, action: #selector(close))
        navigationItem.leftBarButtonItem = closeButton
        
    }
    @objc func close() {
        dismiss(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUrl()
    }
    func loadUrl() {
        if let url = URL(string: restaurant?.couponURL ?? "") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    @IBAction func goBack(_ sender: Any) {
        webView.goBack()
    }
    @IBAction func goForward(_ sender: Any) {
        webView.goForward()
    }
    @IBAction func toSafari(_ sender: Any) {
        guard let url = webView.url else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler:  nil)
        }
    }
}
