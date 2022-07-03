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
    
    var starButtonImage: Driver<UIImage> { get }
    var starButtonTintColor: Driver<UIColor> { get }
    var starButtonAccessibilityIdentifier: Driver<String> { get }
    
    var laterReadButtonImage: Driver<UIImage> { get }
    var laterReadButtonTintColor: Driver<UIColor> { get }
    var laterReadButtonAccessibilityIdentifier: Driver<String> { get }
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
