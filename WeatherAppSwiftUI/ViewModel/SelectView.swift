//
//  SelectView.swift
//  WeatherAppSwiftUI
//

//

import SwiftUI

struct SelectView: View {
    @State var isAvtive = false
    /// 詳細画面に遷移するボタン
    var toDetailViewButton: some View {
        NavigationStack {
            List {
                // 配列の数だけ繰り返し、個別のidとして自身の値を利用する
                ForEach(PrefectureData.prefectures, id:\.self) {prefecture in
                    Button("\(prefecture)") {
                        isAvtive = true
                    }
                    //モーダル遷移
                    .sheet(isPresented: $isAvtive) {
                        DetailView()
                    }
                }
            }
        }
    }
    
    var body: some View {
        toDetailViewButton
        .navigationTitle(Text("都道府県の選択"))
    }
}

struct SelectView_Previews: PreviewProvider {
    static var previews: some View {
        SelectView()
    }
}
