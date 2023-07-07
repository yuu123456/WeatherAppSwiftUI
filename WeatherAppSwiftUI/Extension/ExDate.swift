//
//  ExDate.swift
//  WeatherAppSwiftUI
//

//

import Foundation

extension Date {
    /// 漢字表記yyyy年MM月dd日に変換する
    var formatJapaneseYearDateStyle: String {
        return DateFormatter.formatterJapaneseYearDate.string(from: self)
    }

    /// グラフに表示する日本時間HH:mmに変換する
    var formatJapaneseTimeStyle: String {
        return DateFormatter.formatterJapaneseTime.string(from: self)
    }

    /// セクションに表示する日付"MM月dd日"に変換する
    var formatJapaneseDateStyle: String {
        return DateFormatter.formatterJapaneseDate.string(from: self)
    }

    /// 時間のみ抜き出した値
    var hour: Int {
        Calendar.current.component(.hour, from: self)
    }
    /// 分のみ抜き出した値
    var minute: Int {
        Calendar.current.component(.minute, from: self)
    }
    /// 何時何分と文字列にした値
    var timeString: String {
        String("\(hour)時\(minute)分")
    }
}
