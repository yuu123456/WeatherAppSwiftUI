//
//  DetailViewModel.swift
//  WeatherAppSwiftUI
//

//

import SwiftUI
// ViewModel
class DetailViewModel: ObservableObject {
    @ObservedObject var savedWeatherData = SavedWeatherData()
    @ObservedObject var locationClient = LocationClient.shared
    
    @Published var isLoading = true

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
    func maxTemp(sectionIndex: Int, cellIndex: Int) -> String {
        savedWeatherData.maxTemps[sectionIndex][cellIndex].roundToSecondDecimalPlace().formatted()
    }
    func minTemp(sectionIndex: Int, cellIndex: Int) -> String {
        savedWeatherData.minTemps[sectionIndex][cellIndex].roundToSecondDecimalPlace().formatted()
    }
    func humidity(sectionIndex: Int, cellIndex: Int) -> Int {
        savedWeatherData.humiditys[sectionIndex][cellIndex]
    }
    func iconURL(sectionIndex: Int, cellIndex: Int) -> URL {
        savedWeatherData.iconURL[sectionIndex][cellIndex]
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
    
    func getWeatherData() {
        isLoading = true
        API.share.sendAPIRequest(savedWeatherData: savedWeatherData) { result in
            switch result {
            case .success(let weather):
                print("データ取得成功")
//                print(weather)
                self.saveAPIResponse(response: weather)
            case .failure(let error):
                print("データ取得失敗")
//                print(error)
            }
        }
        API.share.apiCompletionHandler = { [weak self] in
            print("通信完了")
            self!.isLoading = false
            print(self!.isLoading)
        }
    }
    func saveAPIResponse(response: WeatherData) {
        var dateStringArray: [String] = []
        
        savedWeatherData.times = []
        savedWeatherData.pops = []
        savedWeatherData.dates = []
        savedWeatherData.maxTemps = []
        savedWeatherData.minTemps = []
        savedWeatherData.humiditys = []
        savedWeatherData.iconImages = []
        savedWeatherData.iconURL = []
        savedWeatherData.city = response.city.name
        print("格納します")

        for weatherData in response.list {
            let date = Date(timeIntervalSince1970: weatherData.dt)
            let pop = weatherData.pop * 100
            let dateString = date.formatJapaneseDateStyle
            let maxTemp = weatherData.main.maxTemp
            let minTemp = weatherData.main.minTemp
            let humidity = weatherData.main.humidity
            let iconId = weatherData.weather.first!.icon
            let url = URL(string: "https://openweathermap.org/img/wn/\(iconId)@2x.png")
            savedWeatherData.times.append(date)
            savedWeatherData.pops.append(Int(pop))
            
            // 同じ日付を含んでいればインデックス番号取得しその配列に要素を追加、そうでなければ新たな配列として追加
            if let index = dateStringArray.firstIndex(where: {$0 == dateString}) {
                // 含んでいるとき
                savedWeatherData.dates[index].append(date)
                savedWeatherData.maxTemps[index].append(maxTemp)
                savedWeatherData.minTemps[index].append(minTemp)
                savedWeatherData.humiditys[index].append(humidity)
                savedWeatherData.iconURL[index].append(url!)
            } else {
                // 含んでいないとき
                dateStringArray.append(dateString)
                savedWeatherData.dates.append([date])
                savedWeatherData.maxTemps.append([maxTemp])
                savedWeatherData.minTemps.append([minTemp])
                savedWeatherData.humiditys.append([humidity])
                savedWeatherData.iconURL.append([url!])
            }
            if savedWeatherData.times.count == response.list.count {
                print("取得終了、ハンドラ呼び出し")
                API.share.apiCompletionHandler?()
            }
        }
    }
}
