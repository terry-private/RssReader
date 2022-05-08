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
    func toggleStar()
    func toggleLaterRead()
}

final class ArticleDetailModel: ArticleDetailUseCase {
    let disposeBag = DisposeBag()
    let article: BehaviorSubject<Article>
    
    init(_ article: Article) {
        self.article = BehaviorSubject(value: article)
    }
    
    func toggleStar() {
        var newArticle = try! article.value()
        newArticle.isStar = !newArticle.isStar
        CommonData.rssFeedListModel.changeStar(articleKey: newArticle.item.link, isStar: newArticle.isStar)
        article.onNext(newArticle)
    }
    func toggleLaterRead() {
        var newArticle = try! article.value()
        newArticle.laterRead = !newArticle.laterRead
        CommonData.rssFeedListModel.changeLaterRead(articleKey: newArticle.item.link, laterRead: newArticle.laterRead)
        article.onNext(newArticle)
    }
}
