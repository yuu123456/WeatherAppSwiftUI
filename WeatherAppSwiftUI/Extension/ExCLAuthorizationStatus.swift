//
//  ExCLAuthorizationStatus.swift
//  WeatherAppSwiftUI
//

//

import CoreLocation

// 位置情報取得に関するステータスを文字列で返す
extension CLAuthorizationStatus {
    var description: String {
        switch self {
        case .notDetermined:
            return "未選択"
        case .restricted:
            return "ペアレンタルコントロールなどの影響で制限中"
        case .denied:
            return "利用拒否"
        case .authorizedAlways:
            return "常に利用許可"
        case .authorizedWhenInUse:
            return "使用中のみ利用許可"
        default:
            return ""
        }
    }
}
