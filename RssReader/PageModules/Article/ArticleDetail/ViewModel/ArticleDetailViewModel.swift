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
    var viewWillAppear: AnyObserver<Void> { get }
    var tappedClose: AnyObserver<Void> { get }
    var tappedStar: AnyObserver<Void> { get }
    var tappedLaterRead: AnyObserver<Void> { get }
    var tappedBack: AnyObserver<Void> { get }
    var tappedForward: AnyObserver<Void> { get }
    var tappedSafari: AnyObserver<Void> { get }
}

protocol ArticleDetailViewModelOutput: AnyObject {
    var load: Observable<URL> { get }
    var close: Observable<Void> { get }
    var goBack: Observable<Void> { get }
    var goForward: Observable<Void> { get }
    var openSafari: Observable<Void> { get }
    
    var starButtonImage: Observable<UIImage> { get }
    var starButtonTintColor: Observable<UIColor> { get }
    var starButtonAccessibilityIdentifier: Observable<String> { get }
    
    var laterReadButtonImage: Observable<UIImage> { get }
    var laterReadButtonTintColor: Observable<UIColor> { get }
    var laterReadButtonAccessibilityIdentifier: Observable<String> { get }
}

final class ArticleDetailViewModel: ArticleDetailViewModelInput, ArticleDetailViewModelOutput {
    // MARK: Input
    let viewWillAppear: AnyObserver<Void>
    let tappedClose: AnyObserver<Void>
    let tappedStar: AnyObserver<Void>
    let tappedLaterRead: AnyObserver<Void>
    let tappedBack: AnyObserver<Void>
    let tappedForward: AnyObserver<Void>
    let tappedSafari: AnyObserver<Void>
    
    // MARK: Output
    let load: Observable<URL>
    let close: Observable<Void>
    let starButtonImage: Observable<UIImage>
    let starButtonTintColor: Observable<UIColor>
    let starButtonAccessibilityIdentifier: Observable<String>
    
    let laterReadButtonImage: Observable<UIImage>
    let laterReadButtonTintColor: Observable<UIColor>
    let laterReadButtonAccessibilityIdentifier: Observable<String>
    
    let goBack: Observable<Void>
    let goForward: Observable<Void>
    let openSafari: Observable<Void>
    
    private let model: ArticleDetailUseCase
    private let disposeBag = DisposeBag()
    
    init<T: ArticleDetailUseCase>(model: T) {
        self.model = model
        
        // MARK: Input
        
        let _tappedClose = PublishRelay<Void>()
        tappedClose = _tappedClose.asObserver()
        
        let _tappedStar = PublishRelay<Void>()
        _tappedStar
            .subscribe(onNext: { model.toggleStar() })
            .disposed(by: disposeBag)
        tappedStar = _tappedStar.asObserver()
        
        let _tappedLaterRead = PublishRelay<Void>()
        _tappedLaterRead
            .subscribe(onNext: { model.toggleLaterRead() })
            .disposed(by: disposeBag)
        tappedLaterRead = _tappedLaterRead.asObserver()
        
        let _tappedBack = PublishRelay<Void>()
        tappedBack = _tappedBack.asObserver()
        
        let _tappedForward = PublishRelay<Void>()
        tappedForward = _tappedForward.asObserver()
        
        let _tappedSafari = PublishRelay<Void>()
        tappedSafari = _tappedSafari.asObserver()
        
        // MARK: Output
        // close button
        let _close = PublishRelay<Void>()
        close = _close.asObservable()
        _tappedClose
            .bind(to: _close)
            .disposed(by: disposeBag)
        
        // star button
        let _starButtonImage = model.article
            .map { article in
                UIImage(systemName: article.isStar ?  "star.fill" : "star")!
            }
            .asDriver(onErrorDriveWith: .empty())
        
        starButtonImage = _starButtonImage.asObservable()
        
        let _starButtonTintColor: Driver<UIColor> = model.article
            .map { article in
                article.isStar ? .systemYellow : .systemGray
            }
            .asDriver(onErrorDriveWith: .empty())
        
        starButtonTintColor = _starButtonTintColor.asObservable()
        
        let _starButtonAccessibilityIdentifier = model.article
            .map { article in
                article.isStar ? "articleDetail_star_button" : "articleDetail_notStar_button"
            }
            .asDriver(onErrorDriveWith: .empty())
        starButtonAccessibilityIdentifier = _starButtonAccessibilityIdentifier.asObservable()
        
        // later read button
        let _laterReadButtonImage = model.article
            .map { article in
                UIImage(systemName: article.laterRead ?  "tray.fill" : "tray")!
            }
            .asDriver(onErrorDriveWith: .empty())
        laterReadButtonImage = _laterReadButtonImage.asObservable()
        
        let _laterReadButtonTintColor: Driver<UIColor> = model.article
            .map { article in
                article.laterRead ? .systemGreen : .systemBlue
            }
            .asDriver(onErrorDriveWith: .empty())
        laterReadButtonTintColor = _laterReadButtonTintColor.asObservable()
        
        let _laterReadButtonAccessibilityIdentifier = model.article
            .map { article in
                article.laterRead ? "articleDetail_laterRead_button" : "articleDetail_notLaterRead_button"
            }
            .asDriver(onErrorDriveWith: .empty())
        laterReadButtonAccessibilityIdentifier = _laterReadButtonAccessibilityIdentifier.asObservable()
        
        // goBack & goForward
        let _goBack = PublishRelay<Void>()
        goBack = _goBack.asObservable()
        _tappedBack
            .bind(to: _goBack)
            .disposed(by: disposeBag)
        
        let _goForward = PublishRelay<Void>()
        goForward = _goForward.asObservable()
        _tappedForward
            .bind(to: _goForward)
            .disposed(by: disposeBag)
        
        let _openSafari = PublishRelay<Void>()
        openSafari = _openSafari.asObservable()
        _tappedSafari
            .bind(to: _openSafari)
            .disposed(by: disposeBag)
        let _viewWillAppear = PublishRelay<()>()
        viewWillAppear = AnyObserver<Void> { event in
            guard case .next(let element) = event else { return }
            _viewWillAppear.accept(element)
        }
        load = _viewWillAppear
            .map { _ in
                URL(string: try! model.article.value().item.link)!
            }
            .asObservable()
        
    }
}
