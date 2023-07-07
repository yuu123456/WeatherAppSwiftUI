//
//  WeatherData.swift
//  WeatherAppSwiftUI
//

//

import SwiftUI

struct WeatherData: Codable {
    var list: [dataList] = [dataList.init(), dataList.init(), dataList.init(), dataList.init(), dataList.init(), dataList.init(), dataList.init(), dataList.init()]
    var city: City = City.init()
}

struct dataList: Codable {
    var main: Main = Main.init()
    var weather: [Weather] = [Weather.init()]
    /// 降水確率
    var pop: Double = 25
    /// タイムスタンプ
    var dt: TimeInterval = 1661871600
}

struct Main: Codable {
    var maxTemp: Double = 29.45
    var minTemp: Double = 26.34
    var humidity: Int = 80

    enum CodingKeys: String, CodingKey {
        case maxTemp = "temp_max"
        case minTemp = "temp_min"
        case humidity
    }
}

struct Weather: Codable {
    var icon: String = "10n"
}

struct City: Codable {
    var name: String = "東京"
    var coord: Coord = Coord.init()
}

struct Coord: Codable {
    var lat: Double = 44.34
    var lon: Double = 10.99
}
// コーダブルにできないので仮置き
struct WeatherImage {
    var iconImege: [Image] = [Image(systemName: "cloud.rain")]
}
