//
//  RequestParameter.swift
//  WeatherAppSwiftUI
//

//

import Foundation
/// 取得した位置情報をAPIリクエストのパラメータに選択した都道府県名を渡すためのModel
class RequestParameter: ObservableObject {
    /// 選択画面から遷移したかどうかのフラグ（選択画面から遷移した→true）
    @Published var isFromSelectView: Bool?
    @Published var selectLocation: String?
}
