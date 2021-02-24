//
//  ArticleDetailViewController.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/02/24.
//

import UIKit
import WebKit

class ArticleDetailViewController: UIViewController, Transitioner {
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var starButton: UIBarButtonItem!
    var article: Article?
    
    // MARK:- ライフサイクル系
    override func viewDidLoad() {
        super.viewDidLoad()
        let closeButton = UIBarButtonItem(title: "閉じる", style: .plain, target: self, action: #selector(close))
        navigationItem.leftBarButtonItem = closeButton
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUrl()
        setStarButton()
    }
    @objc func close(){
        dismiss(animated: true)
    }
    // MARK:- @IBAction
    @IBAction func goBack(_ sender: Any) {
        webView.goBack()
    }
    @IBAction func goForward(_ sender: Any) {
        webView.goForward()
    }
    @IBAction func toSafari(_ sender: Any) {
        guard let url = URL(string: article?.item.link ?? "") else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler:  nil)
        }
    }
    @IBAction func tappedStarButton(_ sender: Any) {
        guard let star = CommonData.rssFeedListModel.articleList[(article?.item.link)!]?.isStar else { return }
        CommonData.rssFeedListModel.articleList[(article?.item.link)!]?.isStar = !star
        setStarButton()
    }
    
    // MARK:- メソッド系
    func loadUrl() {
        if let url = URL(string: article?.item.link ?? "") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    func setStarButton() {
        if CommonData.rssFeedListModel.articleList[(article?.item.link)!]?.isStar ?? false {
            starButton.image = UIImage(systemName: "star.fill")
            starButton.tintColor = .systemYellow
        } else {
            starButton.image = UIImage(systemName: "star")
            starButton.tintColor = .systemBlue
        }
    }
}

extension ArticleDetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicator.stopAnimating()
    }
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        indicator.startAnimating()
    }
}
