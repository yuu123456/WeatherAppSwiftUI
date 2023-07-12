//
//  SelectViewModel.swift
//  WeatherAppSwiftUI
//

//

import SwiftUI
// ViewModel
class SelectViewModel: ObservableObject {
    // ObservableObjectプロトコルに準拠したクラス内のプロパティを監視し、変化があった際にViewに対して通知を行う
    @Published var isCellTapped = false
    @Published var selectLocation: String = ""
    
    /// 都道府県選択ボタンがタップされた時の処理
    func tappedCell() {
        API.share.selectLocation = selectLocation
        print("APIに\(selectLocation)を渡した")
        isCellTapped.toggle()
    }
}
