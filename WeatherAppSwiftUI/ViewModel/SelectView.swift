//
//  SelectView.swift
//  WeatherAppSwiftUI
//

//

import SwiftUI

struct SelectView: View {
    @StateObject var selectViewModel = SelectViewModel()
    
    /// 詳細画面に遷移するボタン
    var prefecturesList: some View {
        NavigationStack {
            List {
                // 配列の数だけ繰り返し、個別のidとして自身の値を利用する
                ForEach(PrefectureData.prefectures, id:\.self) {prefecture in
                    Button("\(prefecture)") {
                        selectViewModel.tappedCell()
                    }
                    //モーダル遷移
                    .sheet(isPresented: $selectViewModel.isCellTapped) {
                        DetailView()
                    }
                }
            }
        }
        .navigationTitle(Text("都道府県の選択"))
    }
    
    var body: some View {
        prefecturesList
    }
}

struct SelectView_Previews: PreviewProvider {
    static var previews: some View {
        SelectView()
    }
}
