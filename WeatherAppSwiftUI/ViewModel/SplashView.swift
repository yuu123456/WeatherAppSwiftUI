//
//  ContentView.swift
//  WeatherAppSwiftUI
//

//

import SwiftUI

struct SplashView: View {
    /// 画面遷移可否を示す状態変数
    @State private var isActive = false
    /// アニメーション可否を示す変数
    @State var isAnimation = false
    /// スクリーンのサイズ取得し、３分の１とする（見栄え）
    private let imageWidth = UIScreen.main.bounds.width / 3
    
    private var rainImage: some View {
        Image(systemName: "cloud.rain")
            .splashImageModefier(width: imageWidth)
            .offset(x: isAnimation ? -20 : 20)
            .animation(.spring(dampingFraction: 0).repeatForever(), value: isAnimation)
            .foregroundColor(.blue)
    }
    private var sunImage: some View {
        Image(systemName: "sun.max.fill")
            .splashImageModefier(width: imageWidth)
            .rotationEffect(Angle(degrees: isAnimation ? 0 : 360))
            .animation(.linear(duration: 3).repeatForever(autoreverses: false), value: isAnimation)
            .foregroundColor(.red)
    }
    private var cloudImage: some View {
        Image(systemName: "cloud.fill")
            .splashImageModefier(width: imageWidth)
            .scaleEffect(isAnimation ? 15 : 1)
            .animation(.easeIn(duration: 3), value: isAnimation)
            .foregroundColor(.gray)
            // Viewの表示順序を制御するモディファイア（基本はコードの下方が最前面にくるため）
            .zIndex(-1)
    }
    private var boltImage: some View {
        Image(systemName: "cloud.bolt.rain.fill")
            .splashImageModefier(width: imageWidth)
            .opacity(isAnimation ? 0 : 1)
            .animation(.easeInOut(duration: 0.1).repeatForever(), value: isAnimation)
            .foregroundColor(.yellow)
    }
    private var snowImage: some View {
        Image(systemName: "cloud.snow")
            .splashImageModefier(width: imageWidth)
            .offset(y: isAnimation ? -10 : 10)
            .animation(.easeInOut(duration: 1.5).repeatForever(), value: isAnimation)
            .foregroundColor(.cyan)
    }
    
    var body: some View {
        // 画面遷移の設定
        NavigationStack {
            ZStack {
                // 画面いっぱいの背景色（グラデーション）実装
                LinearGradient(gradient: Gradient(colors: [.cyan, .white]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                VStack {
                    HStack {
                        rainImage
                        sunImage
                    }
                    cloudImage
                    HStack {
                        boltImage
                        snowImage
                    }
                }
            }
            
            .onAppear() {
                // 表示と共にアニメーション起動
                isAnimation.toggle()
                // 現在時刻から３秒後に行う処理（時間経過後に自動遷移。タイマーでは画面タップしないと遷移しないため）
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    isActive.toggle()
                }
            }
            // isPresentedの引数trueになればナビゲーション遷移
            .navigationDestination(isPresented: $isActive) {
                // 遷移先画面
                MainView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
