//
//  ArticleTableViewCell.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/02/26.
//

import UIKit
import Nuke

class ArticleTableViewCell: UITableViewCell {
    @IBOutlet weak var rssFeedTypeTitleLabel: UILabel!
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var rssFeedTagLabel: UILabel!
    @IBOutlet weak var articlePubDateLabel: UILabel!
    @IBOutlet weak var faviconImageView: UIImageView!
    @IBOutlet weak var starImageView: UIImageView!
    @IBOutlet weak var readCheckImageView: UIImageView!
    var article: Article? {
        didSet {
            if let url = URL(string: article?.rssFeedFaviconUrl ?? "") {
                Nuke.loadImage(with: url, into: faviconImageView)
            }
            rssFeedTypeTitleLabel.text = article?.rssFeedTitle
            rssFeedTagLabel.text = article?.tag
            articleTitleLabel.text = article?.item.title
            let pubDate = Date(string: article!.item.pubDate!)
            articlePubDateLabel.text = pubDate.longDate()
            if article?.read ?? false {
                readCheckImageView.alpha = 1
            } else {
                readCheckImageView.alpha = 0
            }
            
            if article?.isStar ?? false {
                starImageView.alpha = 1
            } else {
                starImageView.alpha = 0
            }
            
        }
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
