//
//  DetailView.swift
//  WeatherAppSwiftUI
//

//

import SwiftUI

struct DetailView: View {
    /// オブジェクトのインスタンスを監視対象とする属性を付与
    @ObservedObject var savedWeatherData: SavedWeatherData
    
    @StateObject var detailViewModel = DetailViewModel()
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
            Text(savedWeatherData.weatherData.city.name)
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
            savedWeatherData.weatherImage.iconImege[0]
                .padding()
            cellData
                .padding(.horizontal)
        }
    }
    /// セルに内包される気温、湿度のデータ
    var cellData: some View {
        VStack(alignment: .leading) {
            Text("最高気温：\(savedWeatherData.weatherData.list[0].main.maxTemp)℃")
                .fixedSize()
                .padding(.vertical, 1)
            Text("最低気温：\(savedWeatherData.weatherData.list[0].main.minTemp)℃")
                .fixedSize()
                .padding(.vertical, 1)
            Text("湿度：\(savedWeatherData.weatherData.list[0].main.humidity)％")
                .fixedSize()
                .padding(.vertical, 1)
        }
    }
    //背景色
    var backgroundView: some View {
        // 画面いっぱいの背景色（グラデーション）
        LinearGradient(gradient: Gradient(colors: [.cyan, .white]), startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
    }
    
    var body: some View {
        ZStack {
            backgroundView
            VStack {
                closeButton
                header
                chart
                list
            }
        }
        
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(savedWeatherData: SavedWeatherData())
    }
}
