//
//  SortTypeTableViewCell.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/02/26.
//

import UIKit

class SortTypeTableViewCell: UITableViewCell {
    @IBOutlet weak var sortTypeSegmentedControl: UISegmentedControl!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBAction func sortTypeChanged(_ sender: Any) {
        CommonData.filterModel.sortType = SortType.allCases[sortTypeSegmentedControl.selectedSegmentIndex]
    }
}
