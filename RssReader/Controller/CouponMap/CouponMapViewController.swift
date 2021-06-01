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
    func selectedImage() {
        let infomationView = Bundle.main.loadNibNamed("RestaurantInfomationView", owner: self)?.first as? RestaurantInfomationView
        infomationView?.restaurant = restaurant
        iconView = infomationView
        icon = nil
    }
    func unSelectedImage() {
        iconView = nil
        icon = GMSMarker.markerImage(with: nil)
    }
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
    var currentPage = 0
    var couponCellId = "couponCellId"
    lazy var flowLayout = FlowLayout()
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
        
        navigationItem.title = LStrings.couponMap.value
        setCollectionView()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        shopCollectionView.visibleCells.forEach { cell in
            transformScale(cell: cell)
        }
    }
    private func transformScale(cell: UICollectionViewCell) {
        let cellCenter: CGPoint = shopCollectionView.convert(cell.center, to: nil)
        let screenCenterX: CGFloat = UIScreen.main.bounds.width / 2
        let reductionRatio: CGFloat = -0.0005
        let maxScale: CGFloat = 1
        let cellCenterDisX: CGFloat = abs(screenCenterX - cellCenter.x)
        let newScale = reductionRatio * cellCenterDisX + maxScale
        cell.transform = CGAffineTransform(scaleX: newScale, y: newScale)
    }
    
    private func setCollectionView() {
        shopCollectionView.delegate = self
        shopCollectionView.dataSource = self
        shopCollectionView.register(UINib(nibName: "CouponCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: couponCellId)
        shopCollectionView.decelerationRate = .fast
        flowLayout.scrollDirection = .horizontal
        let space = shopCollectionView.bounds.width*0.15
        flowLayout.minimumLineSpacing = 0
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: space, bottom: 0, right: space)
        shopCollectionView.collectionViewLayout = flowLayout
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
        let camera = self.mapView.camera
        let center = camera.target
        var range = 5
        switch camera.zoom {
        case 15.7...21:
            range = 1
        case 14.7..<15.7:
            range = 2
        case 14.2..<14.7:
            range = 3
        case 13.8..<14.2:
            range = 4
        default:
            break
        }
        
        HotpepperAPI.fetchRestaurants(range: range,latitude: center.latitude, longitude: center.longitude) { errorOrRestaurants in
            switch errorOrRestaurants {
            case let .left(error):
                print(error)
            case let .right(restaurants):
                self.displaySearchedSuccess(restaurants: restaurants)
            }
        }
    }
    
    func setCurrentPage(animated: Bool = false) {
        guard let selectedMarker = selectedMarker else {return}
        var index = -1
        for i in 0..<currentRestaurants.count {
            if currentRestaurants[i] == selectedMarker.restaurant! {
                index = i
                break
            }
        }
        if index == -1 { return }
        let x = shopCollectionView.bounds.width*0.7*CGFloat(index)
        shopCollectionView.setContentOffset(CGPoint(x: x, y: 0), animated: animated)
        shopCollectionView.reloadData()
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
                let marker = self.makeMarkerFrom(restaurant: restaurant)
                marker.map = self.mapView
                newMarkers.append(marker)
            }
            self.currentMarkers = newMarkers
            let newRestaurants = newMarkers.map { $0.restaurant! }
            self.currentRestaurants = newRestaurants
            
            if let selectedMarker = self.selectedMarker {
                if !newRestaurants.contains(selectedMarker.restaurant) {
                    self.selectedMarker = nil
                }
            }
            if self.selectedMarker == nil && newMarkers.count > 0 { self.selectedMarker = newMarkers[0]
                newMarkers[0].selectedImage()
            }
            self.shopCollectionView.reloadData()
            self.setCurrentPage()
        }
    }
    
    // MARK: マーカー操作
    private func makeMarkerFrom(restaurant: Restaurant) -> CustomGMSMarker{
        let marker = CustomGMSMarker()
        marker.restaurant = restaurant
        marker.position = CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude)
        marker.appearAnimation = GMSMarkerAnimation.pop
        marker.unSelectedImage()
        return marker
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
        selectedMarker?.unSelectedImage()
        marker.selectedImage()
        selectedMarker = marker
        setCurrentPage(animated: true)
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
        cell.pageNumber = indexPath.row
        if cell.restaurant == selectedMarker?.restaurant {
            cell.selectedRestaurant = true
        } else {
            cell.selectedRestaurant = false
        }
        transformScale(cell: cell)
        return cell
    }

}

extension CouponMapViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: collectionView.bounds.width * 0.7,
            height: collectionView.bounds.height * 0.9
        )
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        flowLayout.prepareForPaging()
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        shopCollectionView.visibleCells.forEach { cell in
            transformScale(cell: cell)
        }
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
//                goCenter(marker: m)
                didTapAt(marker: m)
//                shopCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .right, animated: true)
            }
        }
    }
}

extension CouponMapViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // スクロール完了時に、表示中のページ番号を取得する
        if let collectionView = scrollView as? UICollectionView {
            for cell in collectionView.visibleCells {
                let cellCenter: CGFloat = shopCollectionView.convert(cell.center, to: nil).x
                let screenCenterX: CGFloat = UIScreen.main.bounds.width / 2
                if screenCenterX-1 < cellCenter && cellCenter < screenCenterX+1 {
                    
                    let currentInfoCell = cell as! CouponCollectionViewCell
                    currentPage = currentInfoCell.pageNumber
                    didTapAt(marker: currentMarkers[currentPage])
                    shopCollectionView.reloadData()
                }
            }
        }
    }
}
