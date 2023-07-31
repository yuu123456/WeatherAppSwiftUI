//
//  API.swift
//  WeatherAppSwiftUI
//

//

import Alamofire
import Foundation

final class API {
    static let share = API()
    
    // 通信読み込み中
    var isLoading = true
    
    private let apiKey: String = "5dfc577c1d7d94e9e23a00431582f1ac"
    // 摂氏度にするオプション
    private let units: String = "metric"
    // 日本語にするオプション
    private let lang: String = "ja"
    // 取得するデータ数を制限するオプション（３時間＊８個　＝　２４時間分）
    private let cnt: String = "8"
    
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
    /// 選択した都道府県から天気を取得するAPI Request
    struct GetSelectedLocationWeatherRequest: APIRequest {
        /// 準拠する側で、Responseの型を明示的に指定する
        typealias Response = WeatherData
        
        let selectLocation: String
        
        var parameters: Alamofire.Parameters {
            var parameters = API.share.buildBaseParameters()
            parameters.updateValue(selectLocation, forKey: "q")
            return parameters
        }
        
    }
    /// 位置情報から天気を取得するAPI Request
    struct GetGotLocationWeatherRequest: APIRequest {
        /// 準拠する側で、Responseの型を明示的に指定する
        typealias Response = WeatherData
        
        let latitude: Double
        let longitude: Double
        
        var parameters: Alamofire.Parameters {
            var parameters = API.share.buildBaseParameters()
            parameters.updateValue(latitude, forKey: "lat")
            parameters.updateValue(longitude, forKey: "lon")
            return parameters
        }
        
    }
    /// APIRequestを送るメソッド
    func send<Request: APIRequest>(request: Request,
                                   completion: @escaping ((Result<Request.Response, AFError>) -> Void)) {
        print("リクエスト実行")
        return request.request(request, completion: completion)
    }
}

