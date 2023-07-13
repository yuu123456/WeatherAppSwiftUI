
//
//  MainViewModel.swift
//  WeatherAppSwiftUI
//
//
import SwiftUI
// ViewModel
class MainViewModel: ObservableObject {
    // ObservableObjectプロトコルに準拠したクラス内のプロパティを監視し、変化があった際にViewに対して通知を行う
    @Published var isSelectPrefectureButtonTapped = false
    @Published var isGetLocationButtonTapped = false
    /// 通知予約の有無を示す変数
    @Published var isNotification = false
    
    @ObservedObject var locationClient = LocationClient.shared
    @ObservedObject var savedWeatherData = SavedWeatherData()
    
    /// 通知アイコン名を返すメソッド
    func notificationImageName() -> String {
        switch isNotification {
        case true:
            return "bell"
        case false:
            return "bell.slash"
        }
    }
    /// 都道府県選択ボタンがタップされた時の処理
    func tappedSelectPrefectureButton() {
        isSelectPrefectureButtonTapped.toggle()
    }
    /// 現在地取得ボタンがタップされた時の処理
    func tappedGetLocationButton() {
        self.isGetLocationButtonTapped.toggle()
        locationClient.requestLocation()
    }
}
