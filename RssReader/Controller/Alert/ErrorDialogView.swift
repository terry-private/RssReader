//
//  DialogView.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/05/24.
//

import UIKit

protocol DialogDelegate: AnyObject {
    func tapped()
}

class ErrorDialogView: UIView, DialogProtocol {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dialogView: UIView!
    weak var alertController: DialogDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        dialogView.layer.cornerRadius = 10
    }
    func set(title: String, message: String){
        titleLabel.text = title
        messageLabel.text = message
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    @IBAction func tappedOKButton(_ sender: Any) {
        alertController?.tapped()
    }
}
