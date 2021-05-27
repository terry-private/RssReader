//
//  CouponMapViewController.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/05/26.
//

import UIKit
import GoogleMaps
import GooglePlaces

class CouponMapViewController: UIViewController, Transitioner {
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var shopCollectionView: UICollectionView!
    
    var locationManager: CLLocationManager!
    var placesClient: GMSPlacesClient!
    var preciseLocationZoomLevel: Float = 15.0
    var approximateLocationZoomLevel: Float = 10.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // GoogleMapの初期化
        mapView.isMyLocationEnabled = true
        mapView.mapType = GMSMapViewType.normal
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        mapView.settings.compassButton = true
        mapView.delegate = self
        // 位置情報関連の初期化
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        placesClient = GMSPlacesClient.shared()
    }
    func toHere() {
        
        let camera = GMSCameraPosition.camera(withTarget: locationManager.location!.coordinate, zoom: 15.0)
        self.mapView.animate(to: camera)
    }
}

extension CouponMapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            break
        case .restricted, .denied:
            break
        case .authorizedWhenInUse:
            toHere()
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // マップの初期描画
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            // 位置情報の使用を許可している
            break
        case .notDetermined:
            break
        case .denied, .restricted:
            // 位置情報の使用を許可していない
            manager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: "WantsToSearch") { error in
                print("ok")
            }
            presentErrorAlert(title: "確認", message: "RssReaderで位置情報を取得することができません。設定から位置情報を許可してください。")
//            manager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: "WantsToSearch")
            return
        default:
            // Unhandled case
            return
        }
        
        switch manager.accuracyAuthorization {
        case .fullAccuracy: break
            // 正確な位置情報の使用を許可している
        case .reducedAccuracy: break
            // 正確な位置情報の使用を許可していない
        default: break
            // Unhandled case
        }
        if manager.authorizationStatus != CLAuthorizationStatus.authorizedWhenInUse {
            // アプリの位置情報許可をOFFにしている場合
            
        }
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
