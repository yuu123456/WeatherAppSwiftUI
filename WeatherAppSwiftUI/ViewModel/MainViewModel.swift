//
//  MainViewModel.swift
//  WeatherAppSwiftUI
//

//

import SwiftUI
// ViewModel
class MainViewModel: ObservableObject {
    // ObservableObjectプロトコルに準拠したクラス内のプロパティを監視し、変化があった際にViewに対して通知を行う
    @Published var buttonWidth = UIScreen.main.bounds.width / 1.5
    @Published var isSelectPrefectureButtonTapped = false
    @Published var isGetLocationButtonTapped = false
    /// 通知予約の有無を示す変数
    @Published var isNotification = false
    /// 通知アイコン名を返すメソッド
    func noticationImageName() -> String {
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
        isGetLocationButtonTapped.toggle()
    }
}
