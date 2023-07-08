//
//  SavedWeatherData.swift
//  WeatherAppSwiftUI
//

//

import SwiftUI

class SavedWeatherData: ObservableObject {
    var dates: [[Date]] = [[Date(), Date(), Date()],
                           [Date(), Date(), Date(), Date(), Date()]]
    var maxTemps: [[Double]] = [[30, 30, 30],
                                [30, 30, 30, 30, 30]]
    var minTemps: [[Double]]  = [[30, 30, 30],
                                 [30, 30, 30, 30, 30]]
    var humiditys: [[Int]]  = [[30, 30, 30],
                               [30, 30, 30, 30, 30]]
    var iconImeges: [[Image]] = [[Image(systemName: "cloud.rain"), Image(systemName: "cloud.rain"), Image(systemName: "cloud.rain")],
                               [Image(systemName: "cloud.rain"), Image(systemName: "cloud.rain"), Image(systemName: "cloud.rain"), Image(systemName: "cloud.rain")]]
    
    var times: [Date] = [Date(), Date(), Date(), Date(), Date(), Date(), Date(), Date()]
    var pops: [Double] = [50, 50, 50, 50, 50, 50, 50, 50]
    
    var city: String = "埼玉"
    var lan: Double = 35.81183
    var lon: Double = 139.40863
}
