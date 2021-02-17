//
//  AccountPropertyTableViewCell.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/02/17.
//

import UIKit
import Nuke

class AccountPropertyTableviewCell: UITableViewCell {
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myDisplayNameLabel: UILabel!
    var userConfig: UserConfigProtocol? {
        didSet {
            if let url = userConfig?.photoURL {
                Nuke.loadImage(with: url, into: myImageView)
            }
            myDisplayNameLabel.text = userConfig?.displayName
        }
        
    }
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
