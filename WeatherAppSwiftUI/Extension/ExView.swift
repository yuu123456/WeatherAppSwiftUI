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
}
