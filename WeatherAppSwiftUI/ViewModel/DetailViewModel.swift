//
//  DetailViewModel.swift
//  WeatherAppSwiftUI
//

//

import SwiftUI
// ViewModel
class DetailViewModel: ObservableObject {
    @Published var chartheiht = UIScreen.main.bounds.height / 4
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
    
    /// グラフ用のデータモデルの型に適合させ、戻り値とする。本来はモデル側で処理を記述すべき？
    func chartsData() -> [ChartsData] {
        /// グラフ用のデータモデル型の配列を定義（これを戻り値とする）
        var dataEntrys: [ChartsData] = []
        for i in 0..<savedWeatherData.times.count {
            let dataEntry = ChartsData(xValue: savedWeatherData.times[i], yValue: savedWeatherData.pops[i])
            dataEntrys.append(dataEntry)
        }
        return dataEntrys
    }
}
