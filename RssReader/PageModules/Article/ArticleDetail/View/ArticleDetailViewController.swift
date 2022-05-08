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
    
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var indicator: UIActivityIndicatorView!
    @IBOutlet private weak var laterTrayButton: UIBarButtonItem!
    
    private let starButton = UIBarButtonItem()
    
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
        navigationItem.rightBarButtonItem = starButton
        let closeButton = UIBarButtonItem(title: LStrings.close.value, style: .plain, target: self, action: #selector(close))
        navigationItem.leftBarButtonItem = closeButton
        
        // MARK: Input
        starButton.rx.tap
            .bind(to: input.tappedStar)
            .disposed(by: disposeBag)
        
        laterTrayButton.rx.tap
            .bind(to: input.tappedLaterRead)
            .disposed(by: disposeBag)
        
        // MARK: Output
        // star
        output.starButtonImage
            .drive(starButton.rx.image)
            .disposed(by: disposeBag)
        
        output.starButtonTintColor
            .drive(starButton.rx.tintColor)
            .disposed(by: disposeBag)
        
        // laterRead
        output.laterReadButtonImage
            .drive(laterTrayButton.rx.image)
            .disposed(by: disposeBag)
        
        output.laterReadButtonTintColor
            .drive(laterTrayButton.rx.tintColor)
            .disposed(by: disposeBag)
        
        // テスト用の設定
        view.accessibilityIdentifier = "articleDetail_view"
        closeButton.accessibilityIdentifier = "articleDetail_close_button"
        webView.accessibilityIdentifier = "articleDetail_webView"
        starButton.accessibilityIdentifier = "articleDetail_notStar_button"
        starButton.accessibilityIdentifier = "articleDetail_star_button"
        laterTrayButton.accessibilityIdentifier = "articleDetail_laterRead_button"
        laterTrayButton.accessibilityIdentifier = "articleDetail_notLaterRead_button"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUrl()
    }
    @objc func close() {
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
        guard let url = webView.url else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler:  nil)
        }
    }
    
    // MARK:- メソッド系
    func loadUrl() {
        if let url = URL(string: article?.item.link ?? "") {
            let request = URLRequest(url: url)
            webView.load(request)
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
