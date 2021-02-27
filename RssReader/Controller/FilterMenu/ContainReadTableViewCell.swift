//
//  ContainReadTableViewCell.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/02/26.
//

import UIKit

class ContainReadTableViewCell: UITableViewCell {
    @IBOutlet weak var readLabel: UILabel!
    @IBOutlet weak var readSwitch: UISwitch!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBAction func readChanged(_ sender: Any) {
        CommonData.filterModel.containRead = readSwitch.isOn
    }
}
