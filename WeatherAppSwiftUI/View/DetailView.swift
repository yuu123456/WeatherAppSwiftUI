//
//  DetailView.swift
//  WeatherAppSwiftUI
//

//

import SwiftUI
import Charts

struct DetailView: View {
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
            Text(detailViewModel.city)
                .font(.title)
                .padding(1)
            Text(detailViewModel.today)
                .padding(1)
            Text("降水確率")
                .padding(.horizontal, 1)
        }
    }
    /// グラフ
    var chart: some View {
        Chart(detailViewModel.chartsData()) { dataPoint in
            LineMark(
                x: .value("時間", dataPoint.xValue),
                y: .value("降水確率", dataPoint.yValue)
            )
        }
        // X軸の設定
        .chartXAxis {
            // 3時間ごとにラベルをつける（表示間隔の調整）
            AxisMarks(values: .stride(by: .hour, count: 3)) { date in
                // グリッドラインの表示
                AxisGridLine()
                // ラベルの形式を指定
                AxisValueLabel(format: .dateTime.hour(.twoDigits(amPM: .omitted)).minute())
            }
        }
        .frame(height: detailViewModel.chartheiht)
        .padding()
    }
    var list: some View {
        List {
            ForEach(0..<detailViewModel.sectionCount) {sectionIndex in
                section(sectionIndex: sectionIndex)
            }
        }
    }
    //以下、some Viewに引数を渡せるようにするため、関数型View FunctionBuilderを用いる（またはstructで変数を定義）
    /// リストに内包されるセクション
    func section(sectionIndex: Int) -> some View {
        Section(detailViewModel.sectionDate(sectionIndex: sectionIndex)) {
            ForEach(0..<detailViewModel.cellCount(section: sectionIndex)) {cellIndex in
                cell(sectionIndex: sectionIndex, cellIndex: cellIndex)
            }
        }
    }
    /// セクションに内包されるセル
    func cell(sectionIndex: Int, cellIndex: Int) -> some View {
        HStack {
            Text(detailViewModel.time(sectionIndex: sectionIndex, cell: cellIndex))
                .fixedSize()
                .padding()
            detailViewModel.iconImage(sectionIndex: sectionIndex, cellIndex: cellIndex)
                .padding()
            cellData(sectionIndex: sectionIndex, cellIndex: cellIndex)
                .padding(.horizontal)
        }
    }
    /// セルに内包される気温、湿度のデータ
    func cellData(sectionIndex: Int, cellIndex: Int) -> some View {
        VStack(alignment: .leading) {
            // .formatted()でStringと明示的に変換しないと、少数第2以下の0000が表示される（SwiftUIのみ）※変換処理は別途レスポンス格納時に実行予定（Viewですべきではない）。
            Text("最高気温：\(detailViewModel.maxTemp(sectionIndex: sectionIndex, cellIndex: cellIndex))℃")
                .fixedSize()
                .padding(.vertical, 1)
            Text("最低気温：\(detailViewModel.minTemp(sectionIndex: sectionIndex, cellIndex: cellIndex))℃")
                .fixedSize()
                .padding(.vertical, 1)
            Text("湿度：\(detailViewModel.humidity(sectionIndex: sectionIndex, cellIndex: cellIndex))％")
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
            ZStack {
                VStack {
                    closeButton
                    Spacer()
                }
                VStack {
                    header
                    chart
                    list
                }
            }
        }
        
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
    }
}
