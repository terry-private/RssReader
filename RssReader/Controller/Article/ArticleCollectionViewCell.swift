//
//  ArticleCollectionViewCell.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/03/06.
//

import UIKit
import Nuke
import WebKit

class ArticleCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var starImageView: UIImageView!
    @IBOutlet weak var faviconImageView: UIImageView!
    @IBOutlet weak var readImageView: UIImageView!
    @IBOutlet weak var rssFeedTypeLabel: UILabel!
    @IBOutlet weak var rssFeedTagLabel: UILabel!
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articlePubDateLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    var article: Article? {
        didSet {
            if let faviconUrl = URL(string: article?.rssFeedFaviconUrl ?? "") {
                Nuke.loadImage(with: faviconUrl, into: faviconImageView)
            }
            
            // wordpressのapiでサムネイル画像を作成
            let thumbnailUrlString = "https://s.wordpress.com/mshots/v1/\(article!.item.link.addingPercentEncoding(withAllowedCharacters: .urlPasswordAllowed) ?? "")?w=1200"
            if let thumbnailUrl = URL(string: thumbnailUrlString) {
                let request = ImageRequest(
                    url: thumbnailUrl,
                    processors: [ImageProcessors.Resize(size: CGSize(width: 1200, height: 1020), crop: true)]
                )
                Nuke.loadImage(with: request, into: thumbnailImageView)
            }
            rssFeedTypeLabel.text = article?.rssFeedTitle
            rssFeedTagLabel.text = article?.tag
            articleTitleLabel.text = article?.item.title
            let pubDate = Date(string: article!.item.pubDate!)
            articlePubDateLabel.text = pubDate.longDate()
            if article?.read ?? false {
//                readImageView.alpha = 1
                readImageView.tintColor = .systemBlue
            } else {
//                readImageView.alpha = 0
                readImageView.tintColor = .systemGray
            }
            
            if article?.isStar ?? false {
//                starImageView.alpha = 1
                starImageView.tintColor = .systemYellow
            } else {
//                starImageView.alpha = 0
                starImageView.tintColor = .systemGray
            }
            
        }
    }
    
}
