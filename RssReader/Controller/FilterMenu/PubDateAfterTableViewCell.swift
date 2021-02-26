//
//  PubDateAfterTableViewCell.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/02/26.
//

import UIKit

class PubDateAfterTableViewCell: UITableViewCell {
    @IBOutlet weak var pubDateAfterSegmentedControl: UISegmentedControl!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBAction func pubDateAfterChanged(_ sender: Any) {
        CommonData.filterModel.pubDateAfter = pubDateAfterSegmentedControl.selectedSegmentIndex + 1
    }
}
