//
//  ExImage.swift
//  WeatherAppSwiftUI
//

//

import SwiftUI

extension Image {
    ///スプラッシュ画面用のカスタムモディファイアメソッド
    ///resizable対応可能（普通のカスタムモディファイアでは標準モディファイア以外不可能のため）
    func splashImageModefier(width: Double) -> some View {
        self
            // Imageのサイズ変更用モディファイア
            .resizable()
            // Imageの縦横比維持用モディファイア
            .scaledToFit()
            .frame(width: width)
            .padding()
    }
}
