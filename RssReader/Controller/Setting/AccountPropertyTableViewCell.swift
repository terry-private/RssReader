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
    @IBOutlet weak var myDisplayNameTitleLabel: UILabel!
    @IBOutlet weak var myDisplayNameLabel: UILabel!
    var userConfig: UserConfigProtocol? {
        didSet {
            myDisplayNameTitleLabel.text = LStrings.username.value
            if let url = userConfig?.photoURL {
                print(url)
                if userConfig?.loginType == "mail" {
                    myImageView.image = UIImage(contentsOfFile: url.path) ?? UIImage(systemName: "person")
                } else {
                    Nuke.loadImage(with: url, into: myImageView)
                }
            } else {
                myImageView.image = UIImage(systemName: "person")
            }
            myDisplayNameLabel.text = userConfig?.displayName
        }
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        myImageView.layer.cornerRadius = myImageView.bounds.width / 2
    }
    
}
