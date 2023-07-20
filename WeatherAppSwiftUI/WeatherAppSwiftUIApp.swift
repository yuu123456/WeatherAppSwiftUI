//
//  WeatherAppSwiftUIApp.swift
//  WeatherAppSwiftUI
//

//

import SwiftUI

@main
struct WeatherAppSwiftUIApp: App {
    // アプリ全体でオブジェクトを共有する
//    @StateObject var savedWeatherData = SavedWeatherData()
    var body: some Scene {
        WindowGroup {
            SplashView()
            // アプリ全体で使用するオブジェクトを子Viewに渡すとき
//                .environmentObject(RequestParameter())
        }
    }
}
