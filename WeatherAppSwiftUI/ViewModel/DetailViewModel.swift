//
//  DetailViewModel.swift
//  WeatherAppSwiftUI
//

//

import SwiftUI
import CoreLocation
// ViewModel
class DetailViewModel: ObservableObject {
    // データモデルはオプショナル型で宣言し、最後に値を格納することで、仮データに惑わされないメリット
    @Published var savedWeatherData: SavedWeatherData?
    @Published var isDisplayErrorDialog = false

    @Published var errorTitle: String?
    @Published var errorMessage: String?
    
    var requestParameter = RequestParameter()
    
    // デリゲートパターン⑤処理を任される側で、デリゲートを適用させる
    init() {
        LocationClient.shared.delegate = self
    }
    
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
    
    @Published var isLoading = true
    @Published var selectLocation: String?

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
    /// 選択した都道府県から天気を取得するメソッド
    func getWeather(selectLocation: String) {
        let request = API.GetSelectedLocationWeatherRequest(selectLocation: selectLocation)
        API.share.send(request: request) { result in
            switch result {
            case .success(let weather):
                print("データ取得成功")
                self.saveAPIResponse(response: weather)
            case .failure(let error):
                print("データ取得失敗")
                print(error)
                self.errorTitle = "エラー発生"
                self.errorMessage = error.localizedDescription
                self.isDisplayErrorDialog = true
            }
        }
    }
    /// 位置情報から天気を取得するメソッド
    func getWeather(latitude: Double, longitude: Double) {
        let request = API.GetGotLocationWeatherRequest(latitude: latitude, longitude: longitude)
        API.share.send(request: request) { result in
            switch result {
            case .success(let weather):
                print("データ取得成功")
                self.saveAPIResponse(response: weather)
            case .failure(let error):
                print("データ取得失敗")
                print(error)
                self.errorTitle = "エラー発生"
                self.errorMessage = error.localizedDescription
                self.isDisplayErrorDialog = true
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
                dates[index].append(date)
                maxTemps[index].append(maxTemp)
                minTemps[index].append(minTemp)
                humiditys[index].append(humidity)
                iconURL[index].append(url!)
            } else {
                // 含んでいないとき
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

// デリゲートパターン④処理を任される側で、Extensionしてデリゲートプロトコルに準拠、デリゲートメソッド内に実行したい処理を記述
extension DetailViewModel: LocationManagerDelegate {
    func didUpdateLocation(_ location: CLLocationCoordinate2D) {
        print("デリゲートで位置情報が渡された")

        getWeather(latitude: location.latitude, longitude: location.longitude)
    }
    
    func didFailWithError(_ error: Error) {
        print("デリゲートで位置情報取得失敗が渡された")
    }
}
