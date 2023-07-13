//
//  API.swift
//  WeatherAppSwiftUI
//

//

import Alamofire
import Foundation

class API {
//    @ObservedObject var savedWeatherData = SavedWeatherData()
    static let share = API()
    var selectLocation = String()
    // 通信読み込み中
    var isLoading = true
    
    var apiCompletionHandler: (() -> Void)?
    
    private let baseURLString = "https://api.openweathermap.org"
    private let path: String = "/data/2.5/forecast"
    private let method: HTTPMethod = .get
    
    private let apiKey: String = "5dfc577c1d7d94e9e23a00431582f1ac"
    // 摂氏度にするオプション
    private let units: String = "metric"
    // 日本語にするオプション
    private let lang: String = "ja"
    // 取得するデータ数を制限するオプション（３時間＊８個　＝　２４時間分）
    private let cnt: String = "8"
    // URLを構築する
    func buildURLString() -> String {
        let url = baseURLString + path
        return url
    }
    // ベースとなるパラメータを構築する
    func buildBaseParameters() -> Parameters {
        let parameters: Parameters = [
            "apikey": apiKey,
            "units": units,
            "lang": lang,
            "cnt": cnt
        ]
        return parameters
    }
    var urlString: String {
        buildURLString()
    }
    
    func sendAPIRequest(completion: @escaping (Result<WeatherData, Error>) -> Void) {
        var baseParameters = buildBaseParameters()
        // 固有のパラメータを追加する。辞書型のため、appendではない
        baseParameters.updateValue(selectLocation, forKey: "q")
        
        AF.request(urlString, method: method, parameters: baseParameters).response { response in
            guard let data = response.data else {
                print("dataが不適切？")
                return
            }
            let decoder = JSONDecoder()
            do {
                print("成功")
                let response = try decoder.decode(WeatherData.self, from: data)
//                print(response)
                completion(Result.success(response))
            } catch {
                print("失敗")
                print(error.localizedDescription)
                completion(Result.failure(response as! Error))
            }
        }
        print("リクエストした")
    }
}
