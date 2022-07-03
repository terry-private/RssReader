//
//  ArticleDetailViewController.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/02/24.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa

final class ArticleDetailViewController: UIViewController, Transitioner {
    typealias Input = ArticleDetailViewModelInput
    typealias Output = ArticleDetailViewModelOutput
    
    private let input: Input
    private let output: Output
    private var disposeBag = DisposeBag()
    
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var indicator: UIActivityIndicatorView!
    @IBOutlet private weak var laterTrayButton: UIBarButtonItem!
    @IBOutlet private weak var backButton: UIBarButtonItem!
    @IBOutlet private weak var forwardButton: UIBarButtonItem!
    @IBOutlet private weak var safariButton: UIBarButtonItem!
    
    private let closeButton = UIBarButtonItem()
    private let starButton = UIBarButtonItem()
    
    // MARK: - init
    init?(_ coder: NSCoder, viewModel: Input & Output) {
        input = viewModel
        output = viewModel
        super.init(coder: coder)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationItems()
        setAccessibilityIdentifier()
        bindAllItems()
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
        disposeBag ~
            rx.viewWillAppear ~> input.viewWillAppear ~
            closeButton.rx.tap ~> input.tappedClose ~
            starButton.rx.tap ~> input.tappedStar ~
            laterTrayButton.rx.tap ~> input.tappedLaterRead ~
            backButton.rx.tap ~> input.tappedBack ~
            forwardButton.rx.tap ~> input.tappedForward ~
            safariButton.rx.tap ~> input.tappedSafari
        
        // MARK: Output
        let load = Binder(self) { _, url in self.webView.load(URLRequest(url: url)) }
        let close = Binder<Void>(self) { _, _  in self.dismiss(animated: true) }
        let goBack = Binder<Void>(self) { _, _ in self.webView.goBack() }
        let goForward = Binder<Void>(self) { _, _ in self.webView.goForward() }
        let openSafari = Binder<Void>(self) { _, _ in
            guard let url = self.webView.url else { return }
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler:  nil)
            }
        }
        
        disposeBag ~
            output.load ~> load ~
            output.close ~> close ~
            output.starButtonImage ~> starButton.rx.image ~
            output.starButtonTintColor ~> starButton.rx.tintColor ~
            output.starButtonAccessibilityIdentifier ~> starButton.rx.accessibilityIdentifier ~
            output.laterReadButtonImage ~> laterTrayButton.rx.image ~
            output.laterReadButtonTintColor ~> laterTrayButton.rx.tintColor ~
            output.laterReadButtonAccessibilityIdentifier ~> laterTrayButton.rx.accessibilityIdentifier ~
            output.goBack ~> goBack ~
            output.goForward ~> goForward ~
            output.openSafari ~> openSafari
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
