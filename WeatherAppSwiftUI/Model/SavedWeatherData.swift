//
//  SavedWeatherData.swift
//  WeatherAppSwiftUI
//

//

import Foundation
/// モデルのデータを監視可能にするためのプロトコルに準拠する
class SavedWeatherData: ObservableObject {
    // 変化を同期させるために属性の付与
    @Published var weatherData: WeatherData = WeatherData()
    @Published var list: dataList = dataList()
    @Published var main: Main = Main()
    @Published var weather: Weather = Weather()
    @Published var city: City = City()
    @Published var coord: Coord = Coord()
}
