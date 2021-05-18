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
    override func awakeFromNib() {
        super.awakeFromNib()
        readLabel.text = LStrings.displayRead.value
    }
    @IBAction func readChanged(_ sender: Any) {
        CommonData.filterModel.containRead = readSwitch.isOn
        
        // テストのための設定
        readSwitch.accessibilityIdentifier = readSwitch.isOn ? "filterMenu_containRead_switch" : "filterMenu_notContainRead_switch"
    }
}
