//
//  CouponMapViewController.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/05/26.
//

import UIKit
import GoogleMaps

class CouponMapViewController: UIViewController, Transitioner {
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var shopCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.isMyLocationEnabled = true
        mapView.mapType = GMSMapViewType.normal
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        mapView.settings.compassButton = true
        mapView.delegate = self
    }
}
extension CouponMapViewController: GMSMapViewDelegate {

    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        guard let cMarker = marker as? CustomGMSMarker else {
            return nil
        }

        cMarker.tracksInfoWindowChanges = true
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 250, height: 265))

        return view
    }
}
class CustomGMSMarker: GMSMarker {
    
    public var id: String!
    public var name: String!
    public var category: String!
    public var imageURL: String!
    public var restaurantURL: String!
    
    /// 初期化
    override init() {
        super.init()
    }
}
