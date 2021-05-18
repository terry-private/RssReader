//
//  PubDateAfterTableViewCell.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/02/26.
//

import UIKit

class PubDateAfterTableViewCell: UITableViewCell {
    @IBOutlet weak var pubDateAfterSegmentedControl: UISegmentedControl!
    override func awakeFromNib() {
        super.awakeFromNib()
        // セグメント毎のタイトルをローカライズ
        for i in 1...7 {
            var title = String(i)
            title += i == 1 ? LStrings.singularFormOfDay.value : LStrings.pluralFormOfDay.value
            pubDateAfterSegmentedControl.setTitle(title, forSegmentAt: i-1)
        }
        pubDateAfterSegmentedControl.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor:UIColor(named: "MainLabel")!], for: .normal)
    }
    @IBAction func pubDateAfterChanged(_ sender: Any) {
        CommonData.filterModel.pubDateAfter = pubDateAfterSegmentedControl.selectedSegmentIndex + 1
    }
}
