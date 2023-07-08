//
//  DetailViewModel.swift
//  WeatherAppSwiftUI
//

//

import SwiftUI
// ViewModel
class DetailViewModel: ObservableObject {
    @Published var chartheiht = UIScreen.main.bounds.height / 3
    // Obsarbedかどっちか？
    @ObservedObject var savedWeatherData = SavedWeatherData()
    
    ///セクションの数を返すメソッド。メソッドでまたはコンピューテッドプロパティでしか、savedWeatherDataを参照できないため
    var sectionCount: Int {
        savedWeatherData.dates.count
    }
    ///セルの数を返すメソッド。メソッドでしか、savedWeatherDataを参照しつつ、引数を持たせられないため
    func cellCount(section: Int) -> Int {
        savedWeatherData.dates[section].count
    }
    
    var city: String {
        savedWeatherData.city
    }
    var today: String {
        savedWeatherData.dates[0][0].formatJapaneseYearDateStyle
    }
    func sectionDate(sectionIndex: Int) ->String {
        savedWeatherData.dates[sectionIndex][0].formatJapaneseDateStyle
    }
    func time(sectionIndex: Int, cell: Int) -> String {
        savedWeatherData.dates[sectionIndex][cell].formatJapaneseTimeStyle
    }
    func iconImage(sectionIndex: Int, cellIndex: Int) -> Image {
        savedWeatherData.iconImeges[sectionIndex][cellIndex]
    }
    func maxTemp(sectionIndex: Int, cellIndex: Int) -> String {
        savedWeatherData.maxTemps[sectionIndex][cellIndex].roundToSecondDecimalPlace().formatted()
    }
    func minTemp(sectionIndex: Int, cellIndex: Int) -> String {
        savedWeatherData.minTemps[sectionIndex][cellIndex].roundToSecondDecimalPlace().formatted()
    }
    func humidity(sectionIndex: Int, cellIndex: Int) -> Int {
        savedWeatherData.humiditys[sectionIndex][cellIndex]
    }
}
