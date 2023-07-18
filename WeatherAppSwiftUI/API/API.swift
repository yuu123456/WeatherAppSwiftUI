//
//  API.swift
//  WeatherAppSwiftUI
//

//

import Alamofire
import Foundation

class API {
    static let share = API()
    var selectLocation = String()
    var latitude = Double()
    var longitude = Double()
    
    // 通信読み込み中
    var isLoading = true
    
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
    // AFError型にたくさん種類があるが、独自に定義したエラーを使用
    func sendAPIRequest(completion: @escaping (Result<WeatherData, APIError>) -> Void) {
        var baseParameters = buildBaseParameters()
        // 都道府県を選択済かどうかで判定
        if selectLocation == String() {
            // 固有のパラメータを追加する。辞書型のため、appendではない
            baseParameters.updateValue(latitude, forKey: "lat")
            baseParameters.updateValue(longitude, forKey: "lon")
        } else {
            // 固有のパラメータを追加する。辞書型のため、appendではない
            baseParameters.updateValue(selectLocation, forKey: "q")
        }
        // デコードのエラーハンドリングのため、.responseDecodableは用いない
        AF.request(urlString, method: method, parameters: baseParameters).response { response in
            switch response.result {
                // レスポンスの取得成功
            case .success(let data):
                print("APIレスポンス取得成功")
                // デコードにTry
                do {
                    let decoder = JSONDecoder()
                    let weatherData = try decoder.decode(WeatherData.self, from: data!)
                    print("デコード成功")
                    completion(.success(weatherData))
                } catch {
                    // デコードエラー
                    print("デコード失敗")
                    completion(.failure(.responseParseError(error)))
                }
            // レスポンス取得失敗
            case .failure(let error):
                // ネットワーク接続エラー
                print("レスポンス取得失敗")
                completion(.failure(.connectionError(error)))
            }
//            guard let data = response.data else {
//                print("dataが不適切？")
//                return
//            }
//            let decoder = JSONDecoder()
//            do {
//                let response = try decoder.decode(WeatherData.self, from: data)
////                print(response)
//                completion(Result.success(response))
//                print("成功")
//            } catch {
//                print("失敗")
//                print(error.localizedDescription)
//                completion(Result.failure(response as! Error))
//            }
        }
        print("リクエストした")
    }
}
