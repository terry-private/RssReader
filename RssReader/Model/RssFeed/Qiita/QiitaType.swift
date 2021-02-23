//
//  QiitaType.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/02/13.
//

import Foundation
import UIKit

class QiitaType: RssFeedTypeProtocol {
    let title: String = "Qiita"
    let faviconUrl: String = "https://cdn.qiita.com/assets/favicons/public/production-c620d3e403342b1022967ba5e3db1aaa.ico"
    func makeRssFeed(tag: Any) -> RssFeedProtocol? {
        guard let tagString = tag as? String else { return nil }
        return RssFeed(title: title, tag: tagString, url: "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fqiita.com%2Ftags%2F\(tag)%2Ffeed", faviconUrl: faviconUrl)
    }
    func toSelectTag<T>(view: T) where T: Transitioner, T: SelectRssFeedDelegate {
        // アラート画面で新規ノートのタイトルを入力させます。
        var alertTextField: UITextField?
        let alert = UIAlertController(title: "Qiitaの購読記事", message: "タグを入力", preferredStyle: UIAlertController.Style.alert)
        
        // テキストフィールド追加
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            alertTextField = textField
            textField.text = ""
            textField.placeholder = "タグ"
        })
        
        // キャンセルボタン追加
        alert.addAction(
            UIAlertAction(
                title: "Cancel",
                style: UIAlertAction.Style.cancel,
                handler: nil))
        
        // OKボタン追加
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: UIAlertAction.Style.default) { _ in
                if let text = alertTextField?.text {
                    if text != "" { // ちゃんとしたバリデーションはまた作ります。
                        view.setRssFeed(rssFeed: QiitaType().makeRssFeed(tag: text)!)// 強制アンラップ
                        view.dismiss(animated: true)
                    }
                }
            }
        )
        
        view.present(alert, animated: true, completion: nil)
    }
}
