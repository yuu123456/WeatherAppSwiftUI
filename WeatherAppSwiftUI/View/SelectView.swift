//
//  SelectView.swift
//  WeatherAppSwiftUI
//

//

import SwiftUI

struct SelectView: View {
    @StateObject var selectViewModel = SelectViewModel()
    /// 画面を閉じるアクションのインスタンス作成
    @Environment(\.dismiss) private var dismiss
    
    /// 詳細画面に遷移するボタン
    var prefecturesList: some View {
        NavigationStack {
            List {
                // 配列の数だけ繰り返し、個別のidとして自身の値を利用する
                ForEach(PrefectureData.prefectures, id:\.self) {prefecture in
                    Button("\(prefecture)") {
                        selectViewModel.tappedCell()
                    }
                    .tint(Color.black)
                    //モーダル遷移
                    .sheet(isPresented: $selectViewModel.isCellTapped) {
                        DetailView(savedWeatherData: SavedWeatherData())
                    }
                }
            }
        }
        .navigationTitle(Text("都道府県の選択"))
    }
    /// 標準では、現状前画面に戻るボタンの色が変更不可になっているのため、カスタマイズボタンとする
    var backButton: some View {
        Button {
            // 遷移元に戻る
            dismiss()
        } label: {
            Text("Home")
        }
        .font(.subheadline)
        .tint(Color.white)
    }
    
    var body: some View {
        prefecturesList
            .navigationBarBackButtonHidden()
            .toolbar() {
                ToolbarItem(placement: .navigationBarLeading) {
                    backButton
                }
            }
    }
}

struct SelectView_Previews: PreviewProvider {
    static var previews: some View {
        SelectView()
    }
}
