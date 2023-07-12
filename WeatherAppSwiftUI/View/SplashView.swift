//
//  ContentView.swift
//  WeatherAppSwiftUI
//

//

import SwiftUI
// View
struct SplashView: View {
    @StateObject var splashViewModel = SplashViewModel()
    private var imageWidth = UIScreen.main.bounds.width / 3
    
    private var appTitle: some View {
        Text("Weather App！！")
            .font(.system(.largeTitle, design: .rounded))
            .fontWeight(.black)
            .foregroundColor(.yellow)
            .italic()
            .opacity(splashViewModel.isAnimation ? 1 : 0)
            .animation(.easeIn.delay(1.5), value: splashViewModel.isAnimation)
    }
    
    private var rainImage: some View {
        Image(systemName: "cloud.rain")
            .splashImageModefier(width: imageWidth)
            .offset(x: splashViewModel.isAnimation ? -20 : 20)
            .animation(.spring(dampingFraction: 0).repeatForever(), value: splashViewModel.isAnimation)
            .foregroundColor(.blue)
    }
    private var sunImage: some View {
        Image(systemName: "sun.max.fill")
            .splashImageModefier(width: imageWidth)
            .rotationEffect(Angle(degrees: splashViewModel.isAnimation ? 0 : 360))
            .animation(.linear(duration: 3).repeatForever(autoreverses: false), value: splashViewModel.isAnimation)
            .foregroundColor(.red)
    }
    private var cloudImage: some View {
        Image(systemName: "cloud.fill")
            .splashImageModefier(width: imageWidth)
            .scaleEffect(splashViewModel.isAnimation ? 15 : 1)
            .animation(.easeIn(duration: 3), value: splashViewModel.isAnimation)
            .foregroundColor(.gray)
            // Viewの表示順序を制御するモディファイア（基本はコードの下方が最前面にくるため）
            .zIndex(-1)
    }
    private var boltImage: some View {
        Image(systemName: "cloud.bolt.rain.fill")
            .splashImageModefier(width: imageWidth)
            .opacity(splashViewModel.isAnimation ? 0 : 1)
            .animation(.easeInOut(duration: 0.1).repeatForever(), value: splashViewModel.isAnimation)
            .foregroundColor(.yellow)
    }
    private var snowImage: some View {
        Image(systemName: "cloud.snow")
            .splashImageModefier(width: imageWidth)
            .offset(y: splashViewModel.isAnimation ? -10 : 10)
            .animation(.easeInOut(duration: 1.5).repeatForever(), value: splashViewModel.isAnimation)
            .foregroundColor(.cyan)
    }
    private var backgroungView: some View {
        // 画面いっぱいの背景色（グラデーション）実装
        LinearGradient(gradient: Gradient(colors: [.cyan, .white]), startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
    }
    
    var body: some View {
        // 画面遷移の設定
        NavigationStack {
            ZStack {
                backgroungView
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
                appTitle
            }
            .onAppear() {
                // 表示と共にアニメーション起動
                splashViewModel.displaySplashView()
            }
            // isPresentedの引数trueになればナビゲーション遷移
            .navigationDestination(isPresented: $splashViewModel.isActive) {
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
