//
//  LocationClient.swift
//  WeatherAppSwiftUI
//

//

import CoreLocation

final class LocationClient: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    static let shared = LocationClient()
    /// 位置情報のリクエスト状態を示す（これを元に、読み込み画面の表示仮実装？）
    @Published var isRequesting: Bool = false
    /// 位置情報を収める変数
    @Published var location: CLLocationCoordinate2D?
    
    private override init() {
        super.init()
        locationManager.delegate = self
        // アプリ起動時に位置情報許諾（App使用中の許可）ダイアログの表示
        locationManager.requestWhenInUseAuthorization()
    }
    /// 位置情報取得許諾状態を表すプロパティ。許可されていればTrue
    var isAuthorized: Bool {
        let status = locationManager.authorizationStatus
        return status == .authorizedAlways || status == .authorizedWhenInUse
    }

    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    /// 位置情報を１度だけ取得する
    func requestLocation() {
        if isAuthorized {
            print("アプリの位置情報取得が許可されています")
            print("位置情報を取得します")
            locationManager.requestLocation()
            // リクエスト中ステータスOn
            isRequesting = true
        } else {
            print("アプリの位置情報取得が許可されていません")
        }
    }
    func stopUpdatingLocation() {
        print("位置情報取得を中止します")
        locationManager.stopUpdatingLocation()
    }
}

extension LocationClient: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last?.coordinate {
            print("位置情報の取得成功")
            print("緯度：\(location.latitude)")
            print("経度：\(location.longitude)")
            // 監視対象変数に格納する
            LocationClient.shared.location = location
            // 1つ取得したら止めて良い
            LocationClient.shared.stopUpdatingLocation()
            // リクエスト中ステータスをOff
            isRequesting = false
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("位置情報の取得に失敗：\(error)")
        LocationClient.shared.stopUpdatingLocation()
        LocationClient.shared.isRequesting = false
    }

    // 位置情報の許可のステータス変更で呼ばれる
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("didChangeAuthorization status=\(status.description)")
        switch status {
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            break
        case .notDetermined:
            break
        case .restricted:
            break
        case .denied:
            break
        default:
            break
        }
    }
}
