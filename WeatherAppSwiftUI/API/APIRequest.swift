//
//  APIRequest.swift
//  WeatherAppSwiftUI
//

//

import Foundation
import Alamofire
/// Web APIの使用をリクエストの型として表現する
/// 呼び出し側で書き換えることはないため、ゲッタのみ
protocol APIRequest {
    /// WebAPIではリクエストに応じてレスポンスの構造が決まっている
    /// 連想型によりレスポンスの型をリクエストの型に紐付け、リクエストの型からレスポンスの型を決定できるようにする。
    associatedtype Response: Decodable
    
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters { get }
    
    func request<Request: APIRequest>(_ request: Request, completion: @escaping ((Result<Request.Response, AFError>) -> ()))
    func decode(from data: Data) throws -> Response
}
// 共通で普遍的な部分をエクステンションで一元管理し、同じ定義の繰り返しをなくす
extension APIRequest {
    var baseURL: URL { URL(string: "https://api.openweathermap.org")! }
    // 以下も今回は固定
    var path: String { "/data/2.5/forecast" }
    var method: HTTPMethod { .get }
    
    // URLを構築する
    func buildURL() -> URL {
        let url = baseURL.appendingPathComponent(path)
        return url
    }
    
    func request<Request: APIRequest>(_ request: Request, completion: @escaping ((Result<Request.Response, AFError>) -> ())) {
        print("リクエストを作成")
        AF.request(request.buildURL(), method: method, parameters: parameters).response { response in
            guard let data = response.data else {
                print("dataがnil -> ネットワーク未接続")
                completion(.failure(.sessionTaskFailed(error: URLError(.notConnectedToInternet))))
                return
                }
            
            do {
                let statusCode = response.response!.statusCode
                print(statusCode)
                if (200..<300).contains(statusCode) {
                    print("ステータスコードが２００番台")
                    print("レスポンスをデコードします")
                    let weatherData = try request.decode(from: data)
                    completion(.success(weatherData))
                    print("デコード成功")
                } else if (400..<500).contains(statusCode) {
                    print("クライアントエラー（400リクエストが不正、401認証が不足、403リクエスト未許可、404リソースが見つからない")
                    completion(.failure(AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: statusCode))))
                } else if (500..<600).contains(statusCode) {
                    print("サーバーエラー（500サーバー内部エラー、502無効なレスポンス受け取り、503サーバー過負荷orメンテナンス")
                    completion(.failure(AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: statusCode))))
                } else {
                    print("その他のエラー(300リダイレクト）")
                    completion(.failure(AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: statusCode))))
                }
            } catch {
                print("デコード失敗：\(error)")
                completion(.failure(AFError.responseSerializationFailed(reason: .decodingFailed(error: error))))
            }
        }
    }
    func decode(from data: Data) throws -> WeatherData {
        let response = try JSONDecoder().decode(WeatherData.self, from: data)
        return WeatherData(list: response.list, city: response.city)
    }
}
