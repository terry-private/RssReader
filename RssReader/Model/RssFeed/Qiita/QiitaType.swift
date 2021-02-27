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
        return RssFeed(title: title, tag: tagString, url: makeJsonUrl(tag: tagString), faviconUrl: faviconUrl)
    }
    
    // String.addingPercentEncoding(withAllowedCharacters: .urlPasswordAllowed)でtagを含めたQiitaのRssのアドレスを%エンコード
    // https://qiita.com/yum_fishing/items/db029c097197e6b27fba この記事を参考にしてます。
    func makeJsonUrl(tag: String) -> String {
        let qiitaRssUrl = "https://qiita.com/tags/\(tag)/feed".addingPercentEncoding(withAllowedCharacters: .urlPasswordAllowed)!
        return "https://api.rss2json.com/v1/api.json?rss_url=" + qiitaRssUrl
    }
    func toSelectTag<T>(view: T) where T: Transitioner, T: SelectRssFeedDelegate {
        // アラート画面でTagを入力させます。
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
                title: "キャンセル",
                style: UIAlertAction.Style.cancel,
                handler: nil))
        
        // 確定ボタン追加
        alert.addAction(
            UIAlertAction(
                title: "確定",
                style: UIAlertAction.Style.default) { _ in
                if let text = alertTextField?.text {
                    if text == "" { return }
                    let urlString = self.makeJsonUrl(tag: text)
                    if self.urlValidation(urlString) {
                        view.setRssFeed(rssFeed: QiitaType().makeRssFeed(tag: text)!)// 強制アンラップ
                        view.dismiss(animated: true)
                    }
                }
            }
        )
        
        view.present(alert, animated: true, completion: nil)
    }
    func urlValidation(_ urlString: String) -> Bool{
        guard URL(string: urlString) != nil else {
            return false
        }
        return true
    }
}
