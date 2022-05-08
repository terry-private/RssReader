//
//  ArticleDetailModel.swift
//  RssReader
//
//  Created by 若江照仁 on 2022/05/05.
//

import Foundation
import RxSwift
import RxRelay

protocol ArticleDetailUseCase {
    var article: BehaviorSubject<Article> { get }
}

final class ArticleDetailModel: ArticleDetailUseCase {
    let disposeBag = DisposeBag()
    let article: BehaviorSubject<Article>
    
    init(_ article: Article) {
        self.article = BehaviorSubject(value: article)
        self.article.subscribe(
            onNext: {article in
                CommonData.rssFeedListModel.changeLaterRead(articleKey: article.item.link, laterRead: article.laterRead)
            }, onError: {_ in }, onCompleted: {}
        )
        .disposed(by: disposeBag)
    }
}
