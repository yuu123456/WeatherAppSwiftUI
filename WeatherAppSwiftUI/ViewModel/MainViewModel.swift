
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
    @Published var isDisplayDetailView = false
    @Published var isDisplayNotGetLocDialog = false
    /// 通知予約の有無を示す変数
    @Published var isNotification = false
    // 通知解除アラート表示フラグ
    @Published var isPresentedReleaseNotificationAlert = false
    // 通知予約アラート表示フラグ
    @Published var isPresentedReserveNotificationAlert = false
    // 通知解除完了アラート表示フラグ
    @Published var isPresentedDoneReleaseNotificationAlert = false
    // 通知予約完了アラート表示フラグ
    @Published var isPresentedDoneReserveNotificationAlert = false
    // 通知の時間
    @Published var notificationTime = Date()
    // 時間設定画面の表示フラグ
    @Published var isSettingTime = false
    // 通知の許諾状態を示す(trueで通知許可）
    @Published var isNotificationPermissionStatus = false
    // 通知未許可時のアラート表示フラグ
    @Published var isNotNotificationAlert = false
    
    func notificationTimeString() -> String {
        return notificationTime.formatJapaneseTimeStyle
    }
    
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
        API.share.selectLocation = String()
        print("Button Pushed")
        if LocationClient.shared.isAuthorized {
            print("アプリの位置情報取得が許可されています")
            LocationClient.shared.requestLocation()
            // 詳細画面への遷移フラグをOnにする
            isDisplayDetailView = true

        } else {
            print("アプリの位置情報取得が許可されていません")
            isDisplayNotGetLocDialog = true
        }
    }
    /// 通知の許諾状態を確認する
    func checkNotificationPermission() {
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if settings.authorizationStatus == .authorized {
                    print("通知許可済")
                    self.isNotificationPermissionStatus = true
                } else {
                    print("通知未許可")
                    self.isNotificationPermissionStatus = false
                    self.isNotNotificationAlert = true
                }
            }
        }
    }
    /// 通知の有無を確認する
    func checkReservedNotification() {
        /// 通知予約有無の判定
        UNUserNotificationCenter.current().getPendingNotificationRequests { [weak self] array in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if array.isEmpty {
                    print("通知予約なし")
                    self.isNotification = false
                    self.isPresentedReserveNotificationAlert = true
                } else {
                    print("通知予約あり")
                    self.isNotification = true
                    self.isPresentedReleaseNotificationAlert = true
                }
            }
        }
    }
    
    /// 通知ボタンが押された時の処理
    func tappedNotificationButton() {
        print("通知ボタンが押された")
        checkNotificationPermission()
        checkReservedNotification()
    }
    /// 通知予約アラートのOKボタンが押された時
    func tappedReserveOkButton() {
        reserveNotification()
        isSettingTime = false
        isPresentedDoneReserveNotificationAlert = true
    }
    /// 通知予約アラートのキャンセルボタンが押された時
    func tappedReserveCancelButton() {
        isSettingTime = false
    }
    /// 通知解除アラートのOKボタンが押された時
    func tappedReleaseOkButton() {
        releaseNotification()
        isPresentedDoneReleaseNotificationAlert = true
    }
    
    /// 通知を予約する（標準ではバックグラウンド通知のみ、フォアグラウンドは別途設定する必要あり）
    func reserveNotification() {
        // 通知内容の設定
        let content = UNMutableNotificationContent()
        content.title = "今後の天気は・・・？"
        content.body = "通知をタップして、天気予報を確認しよう！"
        content.sound = .default
        
        // 通知したい時間を作成
        var dateComponents = DateComponents()
        dateComponents.hour = notificationTime.hour
        dateComponents.minute = notificationTime.minute
        // 通知トリガーの設定（毎日同時刻に）
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        // 通知リクエストの作成
        let request = UNNotificationRequest(identifier: "DailyNotification", content: content, trigger: trigger)
        // リクエストを追加
        UNUserNotificationCenter.current().add(request)
        isNotification = true
        print("通知予約完了")
    }
    /// 予約した通知を解除する
    func releaseNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        isNotification = false
        print("通知予約解除した")
    }
    
}
