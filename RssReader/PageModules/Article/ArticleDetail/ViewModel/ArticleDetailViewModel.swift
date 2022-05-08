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
    var tappedStar: PublishRelay<Void> { get }
    var tappedLaterRead: PublishRelay<Void> { get }
}

protocol ArticleDetailViewModelOutput: AnyObject {
    var starButtonImage: Driver<UIImage> { get }
    var starButtonTintColor: Driver<UIColor> { get }
    var laterReadButtonImage: Driver<UIImage> { get }
    var laterReadButtonTintColor: Driver<UIColor> { get }
}

final class ArticleDetailViewModel: ArticleDetailViewModelInput, ArticleDetailViewModelOutput {
    // MARK: Input
    let tappedStar = PublishRelay<Void>()
    let tappedLaterRead = PublishRelay<Void>()
    
    // MARK: Output
    let starButtonImage: Driver<UIImage>
    let starButtonTintColor: Driver<UIColor>
    
    let laterReadButtonImage: Driver<UIImage>
    let laterReadButtonTintColor: Driver<UIColor>
    
    
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
    }
}
