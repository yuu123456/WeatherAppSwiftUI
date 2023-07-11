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
    // グラフの高さ指定
    private var chartHeight = UIScreen.main.bounds.height / 5
    /// 前画面に戻るボタン（左揃え）
    var closeButton: some View {
            HStack {
                Button {
                    // 遷移元に戻る
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
                .tint(Color.black)
                .font(.title2)
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
        .foregroundColor(Color.black)
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
            // 3時間ごとにラベルをつける（表示間隔の調整)
            AxisMarks(values: .stride(by: .hour, count: 3), content: { value in
                // グリッドラインの表示
                AxisGridLine()
                AxisTick()
                // ラベルの形式を指定
                AxisValueLabel(content: {
                    let time = detailViewModel.savedWeatherData.times[value.index]
                    Text(time.formatJapaneseTimeStyle)
                })
            })
        }
        // Y軸に単位ラベル表示
        .chartYAxisLabel(position: .topTrailing, content: {
            Text("%")
        })
        .frame(height: chartHeight)
        .padding()
    }
    var list: some View {
        List {
            // idを付与しないと、警告が出る
            ForEach(0..<detailViewModel.sectionCount, id: \.self) {sectionIndex in
                section(sectionIndex: sectionIndex)
            }
            .listRowBackground(Color.clear)
        }
        // スクロールするとセクションが見えなくなるが、背景が透明なスタイル指定
        .listStyle(.insetGrouped)
        // スクロール可能なViewの背景を非表示にする
        .scrollContentBackground(.hidden)
        .background(Color.clear)
    }
    //以下、some Viewに引数を渡せるようにするため、関数型View FunctionBuilderを用いる（またはstructで変数を定義）
    /// リストに内包されるセクション
    func section(sectionIndex: Int) -> some View {
        Section {
            // １セクション辺りの内容
            ForEach(0..<detailViewModel.cellCount(section: sectionIndex), id: \.self) {cellIndex in
                cell(sectionIndex: sectionIndex, cellIndex: cellIndex)
            }
        } header: {
            sectionHeader(sectionIndex: sectionIndex)
        }
    }
    /// セクションに表示する内容
    func sectionHeader(sectionIndex: Int) -> some View {
        Text(detailViewModel.sectionDate(sectionIndex: sectionIndex))
//            .background(Color.clear)
            .foregroundColor(Color.black)
            .font(.headline)
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
        .foregroundColor(Color.black)
    }
    /// セルに内包される気温、湿度のデータ
    func cellData(sectionIndex: Int, cellIndex: Int) -> some View {
        VStack(alignment: .leading) {
            // .formatted()でStringと明示的に変換しないと、少数第2以下の0000が表示される（SwiftUIのみ）※変換処理は別途レスポンス格納時に実行予定（Viewですべきではない）。
            Text("最高気温：\(detailViewModel.maxTemp(sectionIndex: sectionIndex, cellIndex: cellIndex))℃")
                .foregroundColor(.red)
                .fixedSize()
                .padding(.vertical, 1)
            Text("最低気温：\(detailViewModel.minTemp(sectionIndex: sectionIndex, cellIndex: cellIndex))℃")
                .foregroundColor(.blue)
                .fixedSize()
                .padding(.vertical, 1)
            Text("湿度：\(detailViewModel.humidity(sectionIndex: sectionIndex, cellIndex: cellIndex))％")
                .foregroundColor(.green)
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
