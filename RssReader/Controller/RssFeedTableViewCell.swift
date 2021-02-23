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
    var rssFeed: RssFeedProtocol? {
        didSet {
            if let url = URL(string: rssFeed?.faviconUrl ?? "") {
                Nuke.loadImage(with: url, into: faviconImageView)
            }
            titleLabel.text = rssFeed?.title
            tagNameLabel.text = rssFeed?.tag
        }
    }
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

