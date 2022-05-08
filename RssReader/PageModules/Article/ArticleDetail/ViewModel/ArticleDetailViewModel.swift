//
//  ArticleDetailViewModel.swift
//  RssReader
//
//  Created by 若江照仁 on 2022/05/05.
//

import UIKit
import RxSwift
import RxCocoa

protocol ArticleDetailViewModelInput: AnyObject {
    var viewWillAppear: PublishRelay<Void> { get }
    var tappedClose: PublishRelay<Void> { get }
    var tappedStar: PublishRelay<Void> { get }
    var tappedLaterRead: PublishRelay<Void> { get }
    var tappedBack: PublishRelay<Void> { get }
    var tappedForward: PublishRelay<Void> { get }
    var tappedSafari: PublishRelay<Void> { get }
}

protocol ArticleDetailViewModelOutput: AnyObject {
    var load: Observable<URL> { get }
    var close: Observable<Void> { get }
    var goBack: Observable<Void> { get }
    var goForward: Observable<Void> { get }
    var openSafari: Observable<Void> { get }
    
    var starButtonImage: Driver<UIImage> { get }
    var starButtonTintColor: Driver<UIColor> { get }
    var starButtonAccessibilityIdentifier: Driver<String> { get }
    
    var laterReadButtonImage: Driver<UIImage> { get }
    var laterReadButtonTintColor: Driver<UIColor> { get }
    var laterReadButtonAccessibilityIdentifier: Driver<String> { get }
}

final class ArticleDetailViewModel: ArticleDetailViewModelInput, ArticleDetailViewModelOutput {
    // MARK: Input
    let viewWillAppear = PublishRelay<Void>()
    let tappedClose = PublishRelay<Void>()
    let tappedStar = PublishRelay<Void>()
    let tappedLaterRead = PublishRelay<Void>()
    let tappedBack = PublishRelay<Void>()
    let tappedForward = PublishRelay<Void>()
    let tappedSafari = PublishRelay<Void>()
    
    // MARK: Output
    let load: Observable<URL>
    let close: Observable<Void>
    let starButtonImage: Driver<UIImage>
    let starButtonTintColor: Driver<UIColor>
    let starButtonAccessibilityIdentifier: Driver<String>
    
    let laterReadButtonImage: Driver<UIImage>
    let laterReadButtonTintColor: Driver<UIColor>
    let laterReadButtonAccessibilityIdentifier: Driver<String>
    
    let goBack: Observable<Void>
    let goForward: Observable<Void>
    let openSafari: Observable<Void>
    
    private let model: ArticleDetailUseCase
    private let disposeBag = DisposeBag()
    
    init<T: ArticleDetailUseCase>(model: T) {
        self.model = model
        
        // MARK: Input
        tappedStar
            .subscribe(onNext: { model.toggleStar() })
            .disposed(by: disposeBag)
        
        tappedLaterRead
            .subscribe(onNext: { model.toggleLaterRead() })
            .disposed(by: disposeBag)
        
        // MARK: Output
        // close button
        let _close = PublishRelay<Void>()
        close = _close.asObservable()
        tappedClose
            .bind(to: _close)
            .disposed(by: disposeBag)
        
        // star button
        starButtonImage = model.article
            .map { article in
                UIImage(systemName: article.isStar ?  "star.fill" : "star")!
            }
            .asDriver(onErrorDriveWith: .empty())
        
        starButtonTintColor = model.article
            .map { article in
                article.isStar ? .systemYellow : .systemGray
            }
            .asDriver(onErrorDriveWith: .empty())
        
        starButtonAccessibilityIdentifier = model.article
            .map { article in
                article.isStar ? "articleDetail_star_button" : "articleDetail_notStar_button"
            }
            .asDriver(onErrorDriveWith: .empty())
        
        // later read button
        laterReadButtonImage = model.article
            .map { article in
                UIImage(systemName: article.laterRead ?  "tray.fill" : "tray")!
            }
            .asDriver(onErrorDriveWith: .empty())
        
        laterReadButtonTintColor = model.article
            .map { article in
                article.laterRead ? .systemGreen : .systemBlue
            }
            .asDriver(onErrorDriveWith: .empty())
        
        laterReadButtonAccessibilityIdentifier = model.article
            .map { article in
                article.laterRead ? "articleDetail_laterRead_button" : "articleDetail_notLaterRead_button"
            }
            .asDriver(onErrorDriveWith: .empty())
        
        // goBack & goForward
        let _goBack = PublishRelay<Void>()
        goBack = _goBack.asObservable()
        tappedBack
            .bind(to: _goBack)
            .disposed(by: disposeBag)
        
        let _goForward = PublishRelay<Void>()
        goForward = _goForward.asObservable()
        tappedForward
            .bind(to: _goForward)
            .disposed(by: disposeBag)
        
        let _openSafari = PublishRelay<Void>()
        openSafari = _openSafari.asObservable()
        tappedSafari
            .bind(to: _openSafari)
            .disposed(by: disposeBag)
        
        load = viewWillAppear
            .map { _ in
                URL(string: try! model.article.value().item.link)!
            }
            .asObservable()
        
    }
}
