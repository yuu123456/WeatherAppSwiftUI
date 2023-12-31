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
    // 子ViewとしてModelのインスタンスを受け取る
    @EnvironmentObject var requestParameter: RequestParameter

    // グラフの高さ指定
    private var chartHeight = UIScreen.main.bounds.height / 5
    private var iconSize = UIScreen.main.bounds.width / 5

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
            // presetに.alignedを指定することで、グリッド線の下部に来て、最後のラベルも表示可能となる
            AxisMarks(preset: .aligned, values: .stride(by: .hour, count: 3), content: { value in
                // グリッドラインの表示
                AxisGridLine()
                    .foregroundStyle(.gray)
                AxisTick()
                // ラベルの形式を指定
                AxisValueLabel(content: {
                    let time = detailViewModel.savedWeatherData!.times[value.index]
                    Text(time.formatJapaneseTimeStyle)
                        .foregroundColor(.black)
                })
            })
        }
        // Y軸の設定（オートでは、取得データのうち、降水確率が最高３０だと、３０が上限のグラフになってしまう）
        .chartYAxis {
            let values = [0, 25, 50, 75, 100]
            AxisMarks(values: values) { value in
                // グリッドラインの表示
                AxisGridLine()
                    .foregroundStyle(.gray)
                AxisTick()
                
                AxisValueLabel(content: {
                    let pop = values[value.index]
                    Text(String(pop))
                        .foregroundColor(.black)
                })
            }
        }
        // Y軸に単位ラベル表示
        .chartYAxisLabel(position: .topTrailing, content: {
            Text("%")
                .foregroundColor(.black)
        })
        // パラメータガイドの上限値を明示する。これを指定しないと、降水確率０％の時、0%が上に来る不具合あり
        .chartYScale(domain: 0...100)
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
            AsyncImage(url: detailViewModel.iconURL(sectionIndex: sectionIndex, cellIndex: cellIndex)) { image in
                image
                    .resizable()
                    .frame(width: iconSize, height: iconSize)
                    .scaledToFit()
            } placeholder: {
                ProgressView()
                    .tint(.black)
                    .frame(width: iconSize, height: iconSize)
                    .scaledToFit()
            }

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
    // 集約画面
    var detailMainView: some View {
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
        .onAppear() {
            print("詳細画面表示")
        }
    }
    
    // 読込み画面
    var loadingView: some View {
        ProgressView()
            .tint(.black)
            .scaleEffect(2)
            .task {
                print("読込み画面表示")
                if requestParameter.isFromSelectView! {
                    if let selectLocation = requestParameter.selectLocation {
                        print("選択した都道府県から天気取得")
                        detailViewModel.getWeather(selectLocation: selectLocation)
                    }
                } else {
                    print("位置情報から天気取得（ここでは何もしない。デリゲート待ち）")
                }
            }
    }
    
    var body: some View {
        ZStack {
            backgroundView
            if detailViewModel.isLoading {
                loadingView
                // 操作の無効化（ただしスワイプバックは無効化できない）
                    .disabled(true)
            } else {
                detailMainView
            }
        }
        // APIエラー時に表示するダイアログ
        .errorAlertModifier(title: detailViewModel.errorTitle ?? "仮アラートタイトル",
                            message: detailViewModel.errorMessage ?? "仮アラートメッセージ",
                            isPresented: $detailViewModel.isDisplayErrorDialog)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
    }
}
