//
//  SavedWeatherData.swift
//  WeatherAppSwiftUI
//

//

import SwiftUI

class SavedWeatherData: ObservableObject {
    var dates: [[Date]] = [[Date(), Date(), Date()],
                           [Date() + 1000000, Date(), Date(), Date(), Date()]]
    var maxTemps: [[Double]] = [[30, 30, 30],
                                [30, 30, 30, 30, 30]]
    var minTemps: [[Double]]  = [[30, 30, 30],
                                 [30, 30, 30, 30, 30]]
    var humiditys: [[Int]]  = [[30, 30, 30],
                               [30, 30, 30, 30, 30]]
    var iconImeges: [[Image]] = [[Image(systemName: "cloud.rain"), Image(systemName: "cloud.rain"), Image(systemName: "cloud.rain")],
                               [Image(systemName: "cloud.rain"), Image(systemName: "cloud.rain"), Image(systemName: "cloud.rain"), Image(systemName: "cloud.rain"), Image(systemName: "cloud.rain")]]
    
    var times: [Date] = [Date(), Date() + 3 * 3600, Date() + 3 * 3600 * 2, Date() + 3 * 3600 * 4, Date() + 3 * 3600 * 5, Date() + 3 * 3600 * 6, Date() + 3 * 3600 * 7, Date() + 3 * 3600 * 8]
    var pops: [Int] = [20, 50, 30, 60, 50, 70, 90, 0]
    
    var city: String = "埼玉"
    var lan: Double = 35.81183
    var lon: Double = 139.40863
}
