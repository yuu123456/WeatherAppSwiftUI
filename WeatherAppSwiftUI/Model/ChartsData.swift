//
//  ChartsData.swift
//  WeatherAppSwiftUI
//

//

import Foundation
/// グラフのデータモデル
struct ChartsData: Identifiable {
    var id = UUID()
    var xValue: Date
    var yValue: Int
}
