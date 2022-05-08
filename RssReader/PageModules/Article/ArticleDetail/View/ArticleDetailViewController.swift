//
//  ArticleDetailViewController.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/02/24.
//

import UIKit
import WebKit
//import RealmSwift
import RxSwift
import RxCocoa

final class ArticleDetailViewController: UIViewController, Transitioner {
    typealias Input = ArticleDetailViewModelInput
    typealias Output = ArticleDetailViewModelOutput
    
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var indicator: UIActivityIndicatorView!
    @IBOutlet private weak var laterTrayButton: UIBarButtonItem!
    
    private let closeButton = UIBarButtonItem()
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
        setUpNavigationItems()
        setAccessibilityIdentifier()
        bindAllItems()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUrl()
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

private extension ArticleDetailViewController {
    func setUpNavigationItems() {
        closeButton.title = LStrings.close.value
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.rightBarButtonItem = starButton
    }
    
    
    /// Set accessibilityIdentifier for UITest
    func setAccessibilityIdentifier() {
        view.accessibilityIdentifier = "articleDetail_view"
        closeButton.accessibilityIdentifier = "articleDetail_close_button"
        webView.accessibilityIdentifier = "articleDetail_webView"
    }
    
    /// Bind all items to viewModel
    func bindAllItems() {
        // MARK: Input
        closeButton.rx.tap
            .bind(to: input.tappedClose)
            .disposed(by: disposeBag)
        
        starButton.rx.tap
            .bind(to: input.tappedStar)
            .disposed(by: disposeBag)
        
        laterTrayButton.rx.tap
            .bind(to: input.tappedLaterRead)
            .disposed(by: disposeBag)
        
        // MARK: Output
        // close
        output.close
            .bind(to: Binder(self) {_, _ in
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        // star
        output.starButtonImage
            .drive(starButton.rx.image)
            .disposed(by: disposeBag)
        output.starButtonTintColor
            .drive(starButton.rx.tintColor)
            .disposed(by: disposeBag)
        output.starButtonAccessibilityIdentifier
            .drive(starButton.rx.accessibilityIdentifier)
            .disposed(by: disposeBag)
        
        // laterRead
        output.laterReadButtonImage
            .drive(laterTrayButton.rx.image)
            .disposed(by: disposeBag)
        output.laterReadButtonTintColor
            .drive(laterTrayButton.rx.tintColor)
            .disposed(by: disposeBag)
        output.laterReadButtonAccessibilityIdentifier
            .drive(laterTrayButton.rx.accessibilityIdentifier)
            .disposed(by: disposeBag)
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
