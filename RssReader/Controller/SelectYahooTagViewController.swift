//
//  SelectYahooTagViewController.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/02/23.
//

import UIKit

protocol SelectYahooTagViewControllerProtocol: Transitioner {
    
}

class SelectYahooTagViewController: UIViewController, Transitioner {
    @IBOutlet weak var yahooTagTableView: UITableView!
    private let cellId = "cellId"
    weak var delegate: SelectRssFeedDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = "selectYahooTag_view"
        yahooTagTableView.accessibilityIdentifier = "selectYahooTag_table"
        yahooTagTableView.delegate = self
        yahooTagTableView.dataSource = self
    }
}
extension SelectYahooTagViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        YahooTag.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = yahooTagTableView.dequeueReusableCell(withIdentifier: cellId) as! YahooTagTableViewCell
        cell.textLabel?.text = "「\(YahooTag.allCases[indexPath.row].name)」\(LStrings.articleTaggedWith.value)"
        cell.textLabel?.textColor = .init(named: "MainLabel")
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.setRssFeed(rssFeed: YahooType().makeRssFeed(tag: YahooTag.allCases[indexPath.row])!)
        dismiss(animated: true)
    }
}

class YahooTagTableViewCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
