//
//  ExDouble.swift
//  WeatherAppSwiftUI
//

//

import Foundation

extension Double {
    /// 小数第2で四捨五入するメソッド
    func roundToSecondDecimalPlace() -> Double {
        // 通常は小数第一でしか四捨五入できないため、10倍してから四捨五入→10で割る必要がある。
        let roundedValue: Double = (self * 10).rounded() / 10
        return roundedValue
    }
}
