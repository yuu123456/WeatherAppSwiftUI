//
//  WeatherData.swift
//  WeatherAppSwiftUI
//

//

import SwiftUI

struct WeatherData: Codable {
    var list: [DataList]
    var city: City
}

struct DataList: Codable {
    var main: Main
    var weather: [Weather]
    /// 降水確率
    var pop: Double
    /// タイムスタンプ
    var dt: TimeInterval
}

struct Main: Codable {
    var maxTemp: Double
    var minTemp: Double
    var humidity: Int

    enum CodingKeys: String, CodingKey {
        case maxTemp = "temp_max"
        case minTemp = "temp_min"
        case humidity
    }
}

struct Weather: Codable {
    var icon: String
}

struct City: Codable {
    var name: String
    var coord: Coord
}

struct Coord: Codable {
    var lat: Double
    var lon: Double
}
