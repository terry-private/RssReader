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
}

protocol ArticleDetailViewModelOutput: AnyObject {
    var laterReadButtonImage: Driver<UIImage> { get }
    var laterReadButtonColor: Driver<UIColor> { get }
}

final class ArticleDetailViewModel: ArticleDetailViewModelInput, ArticleDetailViewModelOutput {
    // MARK: Input
    let tappedStar = PublishRelay<Void>()
    
    // MARK: Output
    let laterReadButtonImage: Driver<UIImage>
    let laterReadButtonColor: Driver<UIColor>
    
    private let model: ArticleDetailUseCase
    private let disposeBag = DisposeBag()
    
    init<T: ArticleDetailUseCase>(model: T) {
        self.model = model
        tappedStar.subscribe(
                onNext: {
                    var article = try! model.article.value()
                    article.laterRead = !article.laterRead
                    model.article.onNext(article)
                },
                onError: {_ in },
                onCompleted: {}
            )
            .disposed(by: disposeBag)
        
        laterReadButtonImage = model.article
            .map {article in
                UIImage(systemName: article.laterRead ?  "tray.fill" : "tray")!
            }
            .asDriver(onErrorDriveWith: .empty())
        
        laterReadButtonColor = model.article
            .map {article in
                article.laterRead ? .systemGreen : .systemBlue
            }
            .asDriver(onErrorDriveWith: .empty())
    }
}
