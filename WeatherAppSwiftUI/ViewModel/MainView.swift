//
//  MainView.swift
//  WeatherAppSwiftUI
//

//

import SwiftUI

struct MainView: View {
    @State var isActive = false
    // 選択画面に遷移するボタン
    var toSelectViewButton: some View {
        // タップ時のナビゲーション遷移処理
        NavigationLink(destination: {
            // 遷移先画面
            SelectView()
        }, label: {
            Label("都道府県を選択", systemImage: "location")
        })
        .padding()
    }
    // 詳細画面に遷移するボタン
    var toDetailViewButton: some View {
        Button(action: {
            isActive = true
        }, label: {
            Label("現在地を取得", systemImage: "list.bullet")
        })
        .padding()
        //モーダル遷移
        .sheet(isPresented: $isActive) {
            DetailView()
        }
    }
    
    var body: some View {
        VStack {
            toSelectViewButton
            toDetailViewButton
        }
        .navigationTitle(Text("Home"))
        // 戻るボタンを非表示
        .navigationBarBackButtonHidden()
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
