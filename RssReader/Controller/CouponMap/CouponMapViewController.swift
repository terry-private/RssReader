//
//  CouponMapViewController.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/05/26.
//

import UIKit
import GoogleMaps
import GooglePlaces

protocol SelectShopDelegate: AnyObject {
    func selectAt(restaurant: Restaurant)
}

/// マーカーにRestaurantを保持します。
class CustomGMSMarker: GMSMarker {
    public var restaurant: Restaurant!
}

class CouponMapViewController: UIViewController, Transitioner {
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var shopCollectionView: UICollectionView!
    
    var locationManager: CLLocationManager!
    var placesClient: GMSPlacesClient!
    var preciseLocationZoomLevel: Float = 15.0
    var approximateLocationZoomLevel: Float = 10.0
    var infomationView: RestaurantInfomationView?
    var selectedMarker: CustomGMSMarker?
    var currentMarkers = [CustomGMSMarker]()
    var currentRestaurants = [Restaurant]()
    var couponCellId = "couponCellId"
    
    var shouldRemoveInfo = false
    // fetchを呼ぶタイミングを遅らせるためのタイマー
    weak var timer: Timer!
    
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
        
        setCollectionView()
    }
    
    private func setCollectionView() {
        shopCollectionView.delegate = self
        shopCollectionView.dataSource = self
        shopCollectionView.register(UINib(nibName: "CouponCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: couponCellId)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        let space : CGFloat = 20
        let cellSize : CGFloat = shopCollectionView.bounds.height - space
        layout.sectionInset = UIEdgeInsets(top: 10, left: (shopCollectionView.bounds.width-cellSize)/2, bottom: 10, right: shopCollectionView.bounds.width/4-30)
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        shopCollectionView.collectionViewLayout = layout
    }
    
    /// 現在地に強制的に飛びます。
    func toHere() {
        let camera = GMSCameraPosition.camera(withTarget: locationManager.location!.coordinate, zoom: 15.0)
        mapView.animate(to: camera)
    }
    
    func lazyFetch() {
        if timer != nil{
            timer.invalidate()
        }
        
        timer = Timer.scheduledTimer(
            timeInterval: 0.6,
            target: self,
            selector: #selector(self.fetchRestaurants),
            userInfo: nil,
            repeats: false
        )
    }
    
    @objc private func fetchRestaurants() {
        let center = self.mapView.camera.target
        HotpepperAPI.fetchRestaurants(latitude: center.latitude, longitude: center.longitude) { errorOrRestaurants in
            switch errorOrRestaurants {
            case let .left(error):
                print(error)
            case let .right(restaurants):
                self.displaySearchedSuccess(restaurants: restaurants)
            }
        }
    }
    
    func displaySearchedSuccess(restaurants: [Restaurant]) {
        DispatchQueue.main.async {
            var newMarkers = [CustomGMSMarker]()
            for marker in self.currentMarkers {
                if restaurants.contains(marker.restaurant) {
                    newMarkers.append(marker)
                } else {
                    // 新しいレストランリストに無い旧リストのレストランを消去
                    marker.map = nil
                }
            }
            for restaurant in restaurants {
                if self.currentRestaurants.contains(restaurant) { continue }
                // 旧リストに無い新しいレストランのみ表示
                self.putMarker(restaurant: restaurant)
            }
            self.currentMarkers = newMarkers
            self.currentRestaurants = restaurants
            self.shopCollectionView.reloadData()
        }
    }
    
    // MARK: マーカー操作
    private func putMarker(restaurant: Restaurant) {
        let marker = CustomGMSMarker()
        marker.restaurant = restaurant
        marker.position = CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude)
        marker.appearAnimation = GMSMarkerAnimation.pop
        marker.icon = GMSMarker.markerImage(with: nil)
        DispatchQueue.main.async { [weak self] in
            marker.map = self!.mapView
            self!.currentMarkers.append(marker)
            self?.shouldRemoveInfo = true
        }
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
            presentErrorAlert(title: "確認", message: "RssReaderで位置情報を取得することができません。設定から位置情報を許可してください。")
            return
        default:
            // Unhandled case
            return
        }
        
    }
    func goCenter(marker: CustomGMSMarker) {
        let coordinate = CLLocationCoordinate2D(latitude: marker.restaurant.latitude, longitude: marker.restaurant.longitude)
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 15.0)
        mapView.animate(to: camera)
    }
    
    func didTapAt(marker: CustomGMSMarker) {
        infomationView?.removeFromSuperview()
        shouldRemoveInfo = false
        infomationView = Bundle.main.loadNibNamed("RestaurantInfomationView", owner: self)?.first as? RestaurantInfomationView
        infomationView?.restaurant = marker.restaurant
        infomationView?.center.x = mapView.center.x
        infomationView?.center.y += 80
        mapView.addSubview(infomationView!)
        selectedMarker?.icon = GMSMarker.markerImage(with: nil)
        marker.icon = GMSMarker.markerImage(with: .systemBlue)
        selectedMarker = marker
    }
}

extension CouponMapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let marker = marker as? CustomGMSMarker else {
            return false
        }
        didTapAt(marker: marker)
        return false
    }
    /// mapが変化するたびに呼ばれる
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        lazyFetch()
        if shouldRemoveInfo { infomationView?.removeFromSuperview() }
    }
    // 任意タップで吹き出しを消す
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        infomationView?.removeFromSuperview()
        selectedMarker?.icon = GMSMarker.markerImage(with: nil)
        selectedMarker = nil
        shopCollectionView.reloadData()
    }
}

/// MARK: - CollectionView　デリゲート
extension CouponMapViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentRestaurants.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: couponCellId, for: indexPath) as! CouponCollectionViewCell
        cell.restaurant = currentRestaurants[indexPath.row]
        cell.delegate = self
        if cell.restaurant == selectedMarker?.restaurant {
            cell.selectedRestaurant = true
        } else {
            cell.selectedRestaurant = false
        }
        return cell
    }


}


extension CouponMapViewController: SelectShopDelegate{
    func selectAt(restaurant: Restaurant) {
        if selectedMarker?.restaurant == restaurant {
            print("go detail")
            return
        }
        for m in currentMarkers {
            if m.restaurant == restaurant {
                goCenter(marker: m)
                didTapAt(marker: m)
                shopCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .right, animated: true)
            }
        }
    }
}
