//
//  ArticleDetailViewController.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/02/24.
//

import UIKit
import WebKit
import RealmSwift
import RxSwift
import RxCocoa

final class ArticleDetailViewController: UIViewController, Transitioner {
    typealias Input = ArticleDetailViewModelInput
    typealias Output = ArticleDetailViewModelOutput
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var laterTrayButton: UIBarButtonItem!
    
    var article: Article?
    
    private let input: Input
    private let output: Output
    private let disposeBag = DisposeBag()

    
    init?(_ coder: NSCoder, viewModel: Input & Output) {
        input = viewModel
        output = viewModel
        super.init(coder: coder)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- ライフサイクル系
    override func viewDidLoad() {
        super.viewDidLoad()
        let closeButton = UIBarButtonItem(title: LStrings.close.value, style: .plain, target: self, action: #selector(close))
        navigationItem.leftBarButtonItem = closeButton
        
        laterTrayButton.rx.tap
            .bind(to: input.tappedStar)
            .disposed(by: disposeBag)
        
        output.laterReadButtonImage
            .drive(laterTrayButton.rx.image)
            .disposed(by: disposeBag)
        
        output.laterReadButtonColor
            .drive(laterTrayButton.rx.tintColor)
            .disposed(by: disposeBag)
        
        // テスト用の設定
        view.accessibilityIdentifier = "articleDetail_view"
        closeButton.accessibilityIdentifier = "articleDetail_close_button"
        webView.accessibilityIdentifier = "articleDetail_webView"
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
        guard let url = webView.url else { return }
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
            //テスト用の設定
            starButton.accessibilityIdentifier = "articleDetail_notStar_button"
        } else {
            let starButton = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(tappedStar))
            starButton.tintColor = .systemGray
            navigationItem.rightBarButtonItem = starButton
            //テスト用の設定
            starButton.accessibilityIdentifier = "articleDetail_star_button"
        }
    }
    
    func setLaterReadButton() {
        if CommonData.rssFeedListModel.articleList[(article?.item.link)!]?.laterRead ?? false {
            laterTrayButton.image = UIImage(systemName: "tray.fill")
            laterTrayButton.tintColor = .systemGreen
            
            // テストのための設定
            laterTrayButton.accessibilityIdentifier = "articleDetail_laterRead_button"
        } else {
            laterTrayButton.image = UIImage(systemName: "tray")
            laterTrayButton.tintColor = .systemBlue
            
            // テストのための設定
            laterTrayButton.accessibilityIdentifier = "articleDetail_notLaterRead_button"
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
