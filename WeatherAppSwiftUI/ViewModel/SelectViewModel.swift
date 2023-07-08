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
    
    /// 都道府県選択ボタンがタップされた時の処理
    func tappedCell() {
        isCellTapped.toggle()
    }
}
