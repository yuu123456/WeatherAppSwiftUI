//
//  DetailView.swift
//  WeatherAppSwiftUI
//

//

import SwiftUI

struct DetailView: View {
    @StateObject var selectViewModel = SelectViewModel()
    /// 画面を閉じるアクションのインスタンス作成
    @Environment(\.dismiss) private var dismiss
    /// 前画面に戻るボタン（左揃え）
    var closeButton: some View {
            HStack {
                Button {
                    // 遷移元に戻る
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
                .padding()
                Spacer()
            }
    }
    /// ヘッダー（都道府県名や日付、グラフタイトル）
    var header: some View {
        VStack {
            Text("東京都")
                .font(.title)
                .padding(1)
            Text("2023年12月25日")
                .padding(1)
            Text("降水確率")
                .padding(.horizontal, 1)
        }
    }
    /// グラフ
    var chart: some View {
        Rectangle()
            .foregroundColor(.gray)
            .padding()
    }
    /// リスト全体
    var list: some View {
        List {
            ForEach(0..<2) {_ in
                section
            }
        }
    }
    /// リストに内包されるセクション
    var section: some View {
        Section("12月25日") {
            ForEach(0..<4) {_ in
                cell
            }
        }
    }
    /// セクションに内包されるセル
    var cell: some View {
        HStack {
            Text("12:00")
                .fixedSize()
                .padding()
            Image(systemName: "sun.max.fill")
                .padding()
            cellData
                .padding(.horizontal)
        }
    }
    /// セルに内包される気温、湿度のデータ
    var cellData: some View {
        VStack(alignment: .leading) {
            Text("最高気温：24.7℃")
                .fixedSize()
                .padding(.vertical, 1)
            Text("最低気温：24.7℃")
                .fixedSize()
                .padding(.vertical, 1)
            Text("湿度：80％")
                .fixedSize()
                .padding(.vertical, 1)
        }
    }
    
    var body: some View {
        VStack {
            closeButton
            header
            chart
            list
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
    }
}
