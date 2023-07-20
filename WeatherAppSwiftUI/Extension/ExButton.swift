//
//  ExButton.swift
//  WeatherAppSwiftUI
//
//
import SwiftUI

extension Button {
    ///メイン画面用のカスタムモディファイアメソッド
    func mainViewButtonModifier(width: Double) -> some View {
        self
            // テキストを省略させないモディファイア
            .fixedSize()
            .font(.title)
            .padding()
            .frame(width: width)
            .foregroundColor(.black)
            .background(Color.green)
            .cornerRadius(20)
    }
}
