//
//  ArticleDetailViewController.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/02/24.
//

import UIKit
import WebKit
import RealmSwift

class ArticleDetailViewController: UIViewController, Transitioner {
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var laterTrayButton: UIBarButtonItem!
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
        setLaterReadButton()
        setStarButton()
    }
    @objc func close() {
        dismiss(animated: true)
    }
    @objc func tappedStar() {
        let newIsStar = !article!.isStar
        article?.isStar = newIsStar
        CommonData.rssFeedListModel.changeStar(articleKey: article!.item.link, isStar: newIsStar)
        setStarButton()
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
    @IBAction func tappedLaterReadButton(_ sender: Any) {
        let newLaterRead = !article!.laterRead
        article?.laterRead = newLaterRead
        CommonData.rssFeedListModel.changeLaterRead(articleKey: article!.item.link, laterRead: newLaterRead)
        setLaterReadButton()
    }
    
    // MARK:- メソッド系
    func loadUrl() {
        if let url = URL(string: article?.item.link ?? "") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    func setStarButton() {
        let isStar = CommonData.rssFeedListModel.articleList[article!.item.link]?.isStar
        if isStar ?? false {
            let starButton = UIBarButtonItem(image: UIImage(systemName: "star.fill"), style: .plain, target: self, action: #selector(tappedStar))
            starButton.tintColor = .systemYellow
            navigationItem.rightBarButtonItem = starButton
        } else {
            let starButton = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(tappedStar))
            starButton.tintColor = .systemGray
            navigationItem.rightBarButtonItem = starButton
        }
    }
    
    func setLaterReadButton() {
        if CommonData.rssFeedListModel.articleList[(article?.item.link)!]?.laterRead ?? false {
            laterTrayButton.image = UIImage(systemName: "tray.fill")
            laterTrayButton.tintColor = .systemGreen
        } else {
            laterTrayButton.image = UIImage(systemName: "tray")
            laterTrayButton.tintColor = .systemBlue
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
