//
//  SelectRssFeedViewController.swift
//  RssReader
//
//  Created by 若江照仁 on 2020/12/27.
//

import UIKit

protocol SelectRssFeedViewProtocol: Transitioner {
    
}

class SelectRssFeedViewController: UIViewController, SelectRssFeedViewProtocol {
    //------------------------------------------------------------------------------------
    // @IBOutlet
    //------------------------------------------------------------------------------------
    @IBOutlet weak var selectRssFeedTableView: UITableView!
    @IBOutlet weak var selectedCountLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    
    //------------------------------------------------------------------------------------
    // 変数宣言
    //------------------------------------------------------------------------------------
    private var selectRssFeedModel: SelectRssFeedModelProtocol?
    private var cellId = "cellId"
    private var isFirst = true
    
    
    //------------------------------------------------------------------------------------
    // ライフサイクル関連
    //------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTable()
        changedSelectedCount()
    }
    
    func setUpTable() {
        selectRssFeedTableView.delegate = self
        selectRssFeedTableView.dataSource = self
    }
    
    func inject(selectRssFeedModel: SelectRssFeedModelProtocol) {
        self.selectRssFeedModel = selectRssFeedModel
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isFirst {
            let splashViewController = UIStoryboard(name: "Splash", bundle: nil).instantiateInitialViewController() as! SplashViewController
            splashViewController.inject(splashRouter: DummySplashRouter(view:splashViewController, parent: self), autoLoginModel: DummyLoginModel())
            let nav = UINavigationController(rootViewController: splashViewController)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false, completion: nil)
            isFirst = false
        }
    }
    //------------------------------------------------------------------------------------
    // 状態変化系
    //------------------------------------------------------------------------------------
    func changedSelectedCount() {
        setSelectedCountLabel()
        setConfirmButton()
    }
    func setSelectedCountLabel() {
        selectedCountLabel.text = String(selectRssFeedModel?.selectedRssFeedList.count ?? 0)
    }
    func setConfirmButton() {
        confirmButton.isEnabled = (selectRssFeedModel?.selectedRssFeedList.count ?? 0) > 0
    }
    
    //------------------------------------------------------------------------------------
    // @IBAction
    //------------------------------------------------------------------------------------
    @IBAction func tappedConfirmButton(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension SelectRssFeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectRssFeedModel?.rssFeedList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = selectRssFeedTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SelectRssTableViewCell
        let title = selectRssFeedModel?.rssFeedList[indexPath.row] ?? ""
        let isSelected = selectRssFeedModel?.selectedRssFeedList.contains(title) ?? false
        cell.rssFeedTitleLabel?.text = title
        cell.isSelectedRssFeed = isSelected
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = selectRssFeedModel?.rssFeedList[indexPath.row] ?? ""
        let cell = selectRssFeedTableView.cellForRow(at: indexPath) as! SelectRssTableViewCell
        if cell.isSelectedRssFeed {
            selectRssFeedModel?.selectedRssFeedList.remove(title)
            cell.isSelectedRssFeed = false
        } else {
            selectRssFeedModel?.selectedRssFeedList.insert(title)
            cell.isSelectedRssFeed = true
        }
        changedSelectedCount()
    }
    
}


class SelectRssTableViewCell: UITableViewCell {
    @IBOutlet weak var rssFeedTitleLabel: UILabel!
    @IBOutlet weak var isSelectedLabel: UILabel!
    var isSelectedRssFeed: Bool  = false{
        didSet {
            if isSelectedRssFeed {
                isSelectedLabel.textColor = .systemGreen
                isSelectedLabel.text = "選択済み"
            } else {
                isSelectedLabel.textColor = .systemGray
                isSelectedLabel.text = "未選択"
            }
        }
    }
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
