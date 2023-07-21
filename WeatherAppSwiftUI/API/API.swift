//
//  API.swift
//  WeatherAppSwiftUI
//

//

import Alamofire
import Foundation

class API {
    static let share = API()
    
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
    /// 選択した都道府県をパラメータに追加してAPIリクエストする
    func sendAPISelectedLocationRequest(selectLocation: String, completion: @escaping (Result<WeatherData, AFError>) -> Void) {
        var baseParameters = buildBaseParameters()
        // 固有のパラメータを追加する。辞書型のため、appendではない
        baseParameters.updateValue(selectLocation, forKey: "q")
        sendAPIRequest(parameters: baseParameters, completion: completion)
    }
    /// 位置情報をパラメータに追加してAPIリクエストする
    func sendAPIGotLocationRequest(latitude: Double, longitude: Double, completion: @escaping (Result<WeatherData, AFError>) -> Void) {
        var baseParameters = buildBaseParameters()
        // 固有のパラメータを追加する。辞書型のため、appendではない
        baseParameters.updateValue(latitude, forKey: "lat")
        baseParameters.updateValue(longitude, forKey: "lon")
        sendAPIRequest(parameters: baseParameters, completion: completion)
    }
    /// APIリクエストの共通部分
    func sendAPIRequest(parameters: Parameters, completion: @escaping (Result<WeatherData, AFError>) -> Void) {
        AF.request(urlString, method: method, parameters: parameters).response { response in
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
                    print(error)
                    completion(.failure(.parameterEncoderFailed(reason: .encoderFailed(error: error))))
                }
                // レスポンス取得失敗
            case .failure(let error):
                // ネットワーク接続エラー
                print("レスポンス取得失敗")
                completion(.failure(error))
            }
        }
        print("リクエストした")
    }
}
