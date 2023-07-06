//
//  SplashViewModel.swift
//  WeatherAppSwiftUI
//

//

import SwiftUI
// ViewModel
class SplashViewModel: ObservableObject {
    // ObservableObjectプロトコルに準拠したクラス内のプロパティを監視し、変化があった際にViewに対して通知を行う
    @Published var imageWidth = UIScreen.main.bounds.width / 3
    /// 画面遷移可否を示す状態変数
    @Published var isActive = false
    /// アニメーション可否を示す変数
    @Published var isAnimation = false

    /// スプラッシュ画面が表示された時の処理
    func displaySplashView() {
        isAnimation.toggle()
        // 現在時刻から３秒後に行う処理（時間経過後に自動遷移。タイマーでは画面タップしないと遷移しないため）
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.isActive.toggle()
        }
    }

}
