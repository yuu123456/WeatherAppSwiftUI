//
//  ContentView.swift
//  WeatherAppSwiftUI
//

//

import SwiftUI

struct SplashView: View {
    // 画面遷移可否を示す状態変数
    @State private var isActive = false
    
    /// スクリーンのサイズ取得し、３分の１とする（見栄え）
    private let imageWidth = UIScreen.main.bounds.width / 3
    
    var body: some View {
        // 画面遷移の設定
        NavigationStack {
            VStack {
                HStack {
                    Image(systemName: "cloud.rain")
                        .splashImageModefier(width: imageWidth)
                        .foregroundColor(.blue)
                    Image(systemName: "sun.max.fill")
                        .splashImageModefier(width: imageWidth)
                        .foregroundColor(.red)
                }
                
                Image(systemName: "cloud.fill")
                    .splashImageModefier(width: imageWidth)
                    .foregroundColor(.gray)
//                    .padding()
                HStack {
                    Image(systemName: "cloud.bolt.rain.fill")
                        .splashImageModefier(width: imageWidth)
                        .foregroundColor(.yellow)
                    Image(systemName: "cloud.snow")
                        .splashImageModefier(width: imageWidth)
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
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
