////
////  APIError.swift
////  WeatherAppSwiftUI
////
//
////
//
//import Foundation
//import Alamofire
//
//enum APIError: Error {
//    // 通信失敗
//    case connectionError(Error)
//    // デコードエラー
//    case responseParseError(Error)
//    // APIエラー
//    case apiError(Error)
//    
//    /// ダイアログのタイトル
//    var title: String {
//        switch self {
//        case .connectionError:
//            return "通信エラー"
//        case .responseParseError:
//            return "デコードエラー"
//        case .apiError:
//            return "APIエラー"
//        }
//    }
//    /// ダイアログのメッセージ
//    var message: String {
//        switch self {
//        case .connectionError:
//            return "通信環境を確認してください。"
//        case .responseParseError:
//            return "デコードエラーです。開発者にお問い合わせください。"
//        case .apiError:
//            return "APIエラーです。開発者にお問い合わせください。"
//        }
//    }
//}
//
