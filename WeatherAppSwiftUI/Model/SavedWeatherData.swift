//
//  SavedWeatherData.swift
//  WeatherAppSwiftUI
//

//

import SwiftUI

struct SavedWeatherData {
    var dates: [[Date]]
    var maxTemps: [[Double]]
    var minTemps: [[Double]]
    var humiditys: [[Int]]
    var iconImages: [[Image]]
    var iconURL: [[URL]]
    
    var times: [Date]
    var pops: [Int]
    
    var city: String
    var lat: Double
    var lon: Double
}
