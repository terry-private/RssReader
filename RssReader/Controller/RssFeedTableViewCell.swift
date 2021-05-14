//
//  RssFeedTableViewCell.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/02/17.
//

import UIKit
import Nuke

class RssFeedTableViewCell: UITableViewCell {
    @IBOutlet weak var faviconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tagNameLabel: UILabel!
    @IBOutlet weak var articleTaggedWithLabel: UILabel!
    var rssFeed: RssFeedProtocol? {
        didSet {
            if let url = URL(string: rssFeed?.faviconUrl ?? "") {
                Nuke.loadImage(with: url, into: faviconImageView)
            }
            titleLabel.text = rssFeed?.title
            tagNameLabel.text = rssFeed?.tag
            
            // テストのための設定
            faviconImageView.isAccessibilityElement = true
            faviconImageView.accessibilityIdentifier = "rssFeedTableViewCell_favicon_image"
            titleLabel.accessibilityIdentifier = "rssFeedTableViewCell_title_label"
            tagNameLabel.accessibilityIdentifier = "rssFeedTableViewCell_tagName_label"
        }
    }
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

