//
//  ContentView.swift
//  WeatherAppSwiftUI
//

//

import SwiftUI

struct SplashView: View {
    // 画面遷移可否を示す状態変数
    @State private var isActive = false
    
    var body: some View {
        // 画面遷移の設定
        NavigationStack {
            VStack {
                HStack {
                    Image(systemName: "cloud.rain")
                        .foregroundColor(.blue)
                    Image(systemName: "sun.max.fill")
                        .foregroundColor(.red)
                }
                Image(systemName: "cloud.fill")
                    .foregroundColor(.gray)
                HStack {
                    Image(systemName: "cloud.bolt.rain.fill")
                        .foregroundColor(.yellow)
                    Image(systemName: "cloud.snow")
                        .foregroundColor(.cyan)
                }
            }
            .padding()
            // isPresentedの引数trueになればナビゲーション遷移
            .navigationDestination(isPresented: $isActive) {
                // 遷移先画面
                MainView()
            }
        }
        // 画面が表示された時の処理を記述
        .onAppear() {
            // 現在時刻から３秒後に行う処理（時間経過後に自動遷移。タイマーでは画面タップしないと遷移しないため）
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                isActive = true
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
