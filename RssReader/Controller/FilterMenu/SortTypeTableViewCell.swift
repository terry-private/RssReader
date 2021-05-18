//
//  SortTypeTableViewCell.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/02/26.
//

import UIKit

class SortTypeTableViewCell: UITableViewCell {
    @IBOutlet weak var sortTypeSegmentedControl: UISegmentedControl!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // セグメント毎のタイトルをローカライズ
        for i in 0...1 {
            let title = i == 0 ? LStrings.orderByIssueDate.value : LStrings.orderByTypeOfRssFeed.value
            sortTypeSegmentedControl.setTitle(title, forSegmentAt: i)
        }
    }
    @IBAction func sortTypeChanged(_ sender: Any) {
        CommonData.filterModel.sortType = SortType.allCases[sortTypeSegmentedControl.selectedSegmentIndex]
    }
}
