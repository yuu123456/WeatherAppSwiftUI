//
//  SavedWeatherData.swift
//  WeatherAppSwiftUI
//

//

import SwiftUI

class SavedWeatherData: ObservableObject {
    @Published var dates: [[Date]] = [[Date(), Date(), Date()],
                           [Date() + 1000000, Date(), Date(), Date(), Date()]]
    @Published var maxTemps: [[Double]] = [[30, 30, 30],
                                [30, 30, 30, 30, 30]]
    @Published var minTemps: [[Double]]  = [[30, 30, 30],
                                 [30, 30, 30, 30, 30]]
    @Published var humiditys: [[Int]]  = [[30, 30, 30],
                               [30, 30, 30, 30, 30]]
    @Published var iconImages: [[Image]] = [[Image(systemName: "cloud.rain"), Image(systemName: "cloud.rain"), Image(systemName: "cloud.rain")],
                               [Image(systemName: "cloud.rain"), Image(systemName: "cloud.rain"), Image(systemName: "cloud.rain"), Image(systemName: "cloud.rain"), Image(systemName: "cloud.rain")]]
    @Published var iconURL: [[URL]] = []
    
    @Published var times: [Date] = [Date(), Date() + 3 * 3600, Date() + 3 * 3600 * 2, Date() + 3 * 3600 * 4, Date() + 3 * 3600 * 5, Date() + 3 * 3600 * 6, Date() + 3 * 3600 * 7, Date() + 3 * 3600 * 8]
    @Published var pops: [Int] = [20, 50, 30, 60, 50, 70, 90, 0]
    
    @Published var city: String = "埼玉"
    @Published var lan: Double = 35.81183
    @Published var lon: Double = 139.40863
}
