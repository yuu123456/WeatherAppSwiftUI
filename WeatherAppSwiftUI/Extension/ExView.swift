//
//  ExView.swift
//  WeatherAppSwiftUI
//

//

import SwiftUI

extension View {
    ///位置情報取得不可時のアラートをカスタムモディファイアメソッドにしたもの
    func notGetLocationAlertModifier(isPresented: Binding<Bool>) -> some View {
        self
            // テキストを省略させないモディファイア
            .alert("位置情報が取得できません", isPresented: isPresented) {
                Button("閉じる") {
                    print("閉じる押した")
                }
                Button("設定") {
                    print("設定画面へ遷移")
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }
            } message: {
                Text("端末設定を見直してください")
            }
    }
    // APIエラー時のダイアログ
    func errorAlertModifier(title: String, message: String, isPresented: Binding<Bool>) -> some View {
        self
            .alert(title, isPresented: isPresented) {
                Button("閉じる") {
                    
                }
            } message: {
                Text(message)
            }

    }
    
    // 通知予約するダイアログ
    func reserveNotificationAlertModifier(isPresented: Binding<Bool>, notificationTime: Binding<Date>, okClosure: @escaping () -> Void) -> some View {
        self
            .alert("通知予約しますか？", isPresented: isPresented) {
                DatePicker("時刻を選択", selection: notificationTime,displayedComponents: .hourAndMinute)
                Button("キャンセル") {

                }
                Button("予約する") {
                    okClosure()
                }
            } message: {
                Text("通知予約したい時間を設定してください")
            }
    }
    // 通知解除するか尋ねるダイアログ
    func releaseNotificationAlertModifier(isPresented: Binding<Bool>, okClosure: @escaping () -> Void) -> some View {
        self
            .alert("通知予約を解除しますか?", isPresented: isPresented) {
                Button("キャンセル") {

                }
                Button("解除する") {
                    okClosure()
                }
            } message: {
                Text("既に通知が予約されています。通知予約を解除してもよろしいでしょうか？")
            }
    }
    // 通知予約完了ダイアログ
    func doneReserveNotificationAlertModifier(isPresented: Binding<Bool>, notificationTimeString: String) -> some View {
        self
            .alert("通知予約完了", isPresented: isPresented) {
                Button("OK") {
                    
                }
            } message: {
                Text("毎日\(notificationTimeString)に通知が行われます")
            }
    }
    // 通知予約解除完了ダイアログ
    func doneReleaseNotificationAlertModifier(isPresented: Binding<Bool>) -> some View {
        self
            .alert("通知予約解除完了", isPresented: isPresented) {
                Button("OK") {
                    
                }
            } message: {
                Text("毎日の通知予約を解除しました。")
            }
    }
    
    /// 通知許諾不可時のアラートをカスタムモディファイアメソッドにしたもの
    func notPermissionNotificationAlertModifier(isPresented: Binding<Bool>) -> some View {
        self
            // テキストを省略させないモディファイア
            .alert("通知が許可されていません", isPresented: isPresented) {
                Button("閉じる") {
                    print("閉じる押した")
                }
                Button("設定") {
                    print("設定画面へ遷移")
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }
            } message: {
                Text("端末設定を見直してください")
            }
    }
}
