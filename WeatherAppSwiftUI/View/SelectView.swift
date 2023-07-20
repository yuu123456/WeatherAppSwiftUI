//
//  SelectView.swift
//  WeatherAppSwiftUI
//

//

import SwiftUI

struct SelectView: View {
    @ObservedObject var selectViewModel = SelectViewModel()
    /// 画面を閉じるアクションのインスタンス作成
    @Environment(\.dismiss) private var dismiss
    // 親Viewとする
    @ObservedObject var requestParameter = RequestParameter()
    
    /// 詳細画面に遷移するボタン
    var prefecturesList: some View {
        NavigationStack {
            List {
                // 配列の数だけ繰り返し、個別のidとして自身の値を利用する
                ForEach(PrefectureData.prefectures, id:\.self) {prefecture in
                    Button("\(prefecture)") {
                        requestParameter.isFromSelectView = true
                        requestParameter.selectLocation = prefecture
                        selectViewModel.tappedCell()
                    }
                }
                .listRowBackground(Color.clear)
            }
            // スクロール可能なViewの背景を非表示にする
            .scrollContentBackground(.hidden)
            .background(Color.clear)
        }
        .tint(Color.black)
        //モーダル遷移 ※NavigationStackに付与すると、DetailViewの.onAppearが１３回も呼ばれる
        .sheet(isPresented: $selectViewModel.isCellTapped) {
            DetailView()
            // 子Viewに渡す
                .environmentObject(requestParameter)
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
    
    //背景色
    var backgroundView: some View {
        // 画面いっぱいの背景色（グラデーション）
        LinearGradient(gradient: Gradient(colors: [.cyan, .white]), startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
    }
    
    var body: some View {
        ZStack {
            backgroundView
            prefecturesList
                .navigationBarBackButtonHidden()
                .toolbar() {
                    ToolbarItem(placement: .navigationBarLeading) {
                        backButton
                    }
                }
        }
    }
}

struct SelectView_Previews: PreviewProvider {
    static var previews: some View {
        SelectView()
    }
}
