//
//  DetailViewModel.swift
//  WeatherAppSwiftUI
//

//

import SwiftUI
// ViewModel
class DetailViewModel: ObservableObject {
    // データモデルはオプショナル型で宣言し、最後に値を格納することで、仮データに惑わされないメリット
    @Published var savedWeatherData: SavedWeatherData?
    
    // 仮に格納するための変数を宣言する
    private var dates: [[Date]] = []
    private var maxTemps: [[Double]] = []
    private var minTemps: [[Double]] = []
    private var humiditys: [[Int]] = []
    private var iconImages: [[Image]] = []
    private var iconURL: [[URL]] = []
    private var times: [Date] = []
    private var pops: [Int] = []
    var city: String = String()
    private var lat: Double = Double()
    private var lon: Double = Double()

    @ObservedObject var locationClient = LocationClient.shared
    
    @Published var isLoading = true

    ///セクションの数を返すメソッド。メソッドでまたはコンピューテッドプロパティでしか、savedWeatherDataを参照できないため
    var sectionCount: Int {
        savedWeatherData!.dates.count
    }
    ///セルの数を返すメソッド。メソッドでしか、savedWeatherDataを参照しつつ、引数を持たせられないため
    func cellCount(section: Int) -> Int {
        savedWeatherData!.dates[section].count
    }
    var today: String {
        savedWeatherData!.dates[0][0].formatJapaneseYearDateStyle
    }
    func sectionDate(sectionIndex: Int) ->String {
        savedWeatherData!.dates[sectionIndex][0].formatJapaneseDateStyle
    }
    func time(sectionIndex: Int, cell: Int) -> String {
        savedWeatherData!.dates[sectionIndex][cell].formatJapaneseTimeStyle
    }
    func maxTemp(sectionIndex: Int, cellIndex: Int) -> String {
        savedWeatherData!.maxTemps[sectionIndex][cellIndex].roundToSecondDecimalPlace().formatted()
    }
    func minTemp(sectionIndex: Int, cellIndex: Int) -> String {
        savedWeatherData!.minTemps[sectionIndex][cellIndex].roundToSecondDecimalPlace().formatted()
    }
    func humidity(sectionIndex: Int, cellIndex: Int) -> Int {
        savedWeatherData!.humiditys[sectionIndex][cellIndex]
    }
    func iconURL(sectionIndex: Int, cellIndex: Int) -> URL {
        savedWeatherData!.iconURL[sectionIndex][cellIndex]
    }
    
    /// グラフ用のデータモデルの型に適合させ、戻り値とする。本来はモデル側で処理を記述すべき？
    func chartsData() -> [ChartsData] {
        /// グラフ用のデータモデル型の配列を定義（これを戻り値とする）
        var dataEntrys: [ChartsData] = []
        for i in 0..<savedWeatherData!.times.count {
            let dataEntry = ChartsData(xValue: savedWeatherData!.times[i], yValue: savedWeatherData!.pops[i])
            dataEntrys.append(dataEntry)
        }
        return dataEntrys
    }
    
    func getWeatherData() async {
        isLoading = true
        API.share.sendAPIRequest() { result in
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
    }
    
    func saveAPIResponse(response: WeatherData) {
        var dateStringArray: [String] = []

        city = response.city.name
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
            times.append(date)
            pops.append(Int(pop))
            
            // 同じ日付を含んでいればインデックス番号取得しその配列に要素を追加、そうでなければ新たな配列として追加
            if let index = dateStringArray.firstIndex(where: {$0 == dateString}) {
                // 含んでいるとき
                print("含む")
                dates[index].append(date)
                maxTemps[index].append(maxTemp)
                minTemps[index].append(minTemp)
                humiditys[index].append(humidity)
                iconURL[index].append(url!)
            } else {
                // 含んでいないとき
                print("含まず")
                dateStringArray.append(dateString)
                dates.append([date])
                maxTemps.append([maxTemp])
                minTemps.append([minTemp])
                humiditys.append([humidity])
                iconURL.append([url!])
            }

            if times.count == response.list.count {
                savedWeatherData = SavedWeatherData(dates: dates, maxTemps: maxTemps, minTemps: minTemps, humiditys: humiditys, iconImages: iconImages, iconURL: iconURL, times: times, pops: pops, city: city, lat: lat, lon: lon)
                print("取得終了")
                self.isLoading = false
            }
        }
    }
}
