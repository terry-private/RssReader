//
//  RssFeedDisplayTableViewCell.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/02/26.
//

import UIKit
import Nuke

class RssFeedDisplayTableViewCell: UITableViewCell {
    @IBOutlet weak var faviconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tagNameLabel: UILabel!
    @IBOutlet weak var isDisplay: UISwitch!
    @IBOutlet weak var articleTaggedWithLabel: UILabel!
    var rssFeedKey: String? {
        didSet {
            guard let rssFeed = CommonData.rssFeedListModel.rssFeedList[rssFeedKey!] else { return }
            if let url = URL(string: rssFeed.faviconUrl) {
                Nuke.loadImage(with: url, into: faviconImageView)
            }
            tagNameLabel.text = rssFeed.tag
            titleLabel.text = rssFeed.title
            isDisplay.setOn(rssFeed.display, animated: true)
            
            // テストのための設定
            tagNameLabel.accessibilityIdentifier = "filterMenu_rssFeedTag_label"
            isDisplay.accessibilityIdentifier = isDisplay.isOn ? "filterMenu_rssFeedDisplay_switch": "filterMenu_rssFeedNotDisplay_switch"
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        articleTaggedWithLabel.text = LStrings.articleTaggedWith.value
    }
    @IBAction func changedIsDisplay(_ sender: Any) {
        CommonData.rssFeedListModel.rssFeedList[rssFeedKey!]?.display = isDisplay.isOn
        
        // テストのための設定
        isDisplay.accessibilityIdentifier = isDisplay.isOn ? "filterMenu_rssFeedDisplay_switch": "filterMenu_rssFeedNotDisplay_switch"
    }
}
