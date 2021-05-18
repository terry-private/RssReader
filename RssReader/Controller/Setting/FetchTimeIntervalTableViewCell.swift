//
//  FetchTimeIntervalTableViewCell.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/03/03.
//

import UIKit

class FetchTimeIntervalTableViewCell: UITableViewCell {
    @IBOutlet weak var fetchTimeIntervalSegmentedControl: UISegmentedControl!
    private let timeIntervals = [1, 3, 5, 10]
    override func awakeFromNib() {
        super.awakeFromNib()
        // セグメント毎のタイトル文字列をローカライズ
        // 単数形と複数形を分岐で分けています。
        for i in 0..<timeIntervals.count {
            let title = String(timeIntervals[i]) + (timeIntervals[i] == 1 ? LStrings.singularFormOfMinute.value : LStrings.pluralFormOfMinute.value)
            fetchTimeIntervalSegmentedControl.setTitle(title, forSegmentAt: i)
        }
        fetchTimeIntervalSegmentedControl.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor:UIColor(named: "MainLabel")!], for: .normal)
    }
    @IBAction func ChangedFetchTimeInterval(_ sender: Any) {
        CommonData.filterModel.fetchTimeInterval = timeIntervals[fetchTimeIntervalSegmentedControl.selectedSegmentIndex]
    }
}
