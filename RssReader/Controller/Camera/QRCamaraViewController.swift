//
//  QRCamaraViewController.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/06/02.
//

import UIKit
import AVFoundation

class QRCameraViewController: UIViewController {

    let qRCodeReader = QRCodeReader()
    var isOpenMenu = false
    
    @IBOutlet weak var cameraView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        qRCodeReader.delegate = self
        qRCodeReader.setupCamera(view:cameraView)
        //読み込めるカメラ範囲
        qRCodeReader.readRange()
    }
}

extension QRCameraViewController: AVCaptureMetadataOutputObjectsDelegate{
    //対象を認識、読み込んだ時に呼ばれる
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if isOpenMenu { return }
        //一画面上に複数のQRがある場合、複数読み込むが今回は便宜的に先頭のオブジェクトを処理
        if let metadata = metadataObjects.first as? AVMetadataMachineReadableCodeObject{
            let barCode = qRCodeReader.previewLayer.transformedMetadataObject(for: metadata) as! AVMetadataMachineReadableCodeObject
            //読み込んだQRを映像上で枠を囲む。ユーザへの通知。必要な時は記述しなくてよい。
            qRCodeReader.qrView.frame = barCode.bounds
            //QRデータを表示
            if let str = metadata.stringValue {
                isOpenMenu = true
                let ac = UIAlertController(title: "Select Action", message: str, preferredStyle: .actionSheet)
                
                ac.addAction(getCopyAction(str: str))
                ac.addAction(getSafariAction(str: str))
                ac.addAction(UIAlertAction(title: LStrings.cancel.value, style: .cancel, handler: { _ in
                    self.isOpenMenu = false
                }))
                present(ac, animated: true, completion: nil)
            }
        }
    }
    private func getCopyAction(str: String) -> UIAlertAction {
        let action = UIAlertAction(
            title: "Copy",
            style: .default,
            handler: { _ in
                UIPasteboard.general.string = str
                self.isOpenMenu = false
            }
        )
        return action
    }
    
    private func getSafariAction(str: String) -> UIAlertAction {
        let action = UIAlertAction(
            title: "To Safari",
            style: .default,
            handler: { _ in
                self.isOpenMenu = false
                guard let url = URL(string: str) else { return }
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler:  nil)
                }
            }
        )
        return action
    }
}
