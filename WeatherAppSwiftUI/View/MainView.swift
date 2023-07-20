//
//  MainView.swift
//  WeatherAppSwiftUI
//
//
import SwiftUI

// View
struct MainView: View {
    @StateObject private var mainViewModel = MainViewModel()
    private var buttonWidth = UIScreen.main.bounds.width / 1.5

    /// ナビゲーションバーの設定を行うメソッド
    func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .darkGray
        appearance.shadowColor = .black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        // ナビゲーションバーに反映
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    init() {
        setupNavigationBar()
        
        let center = UNUserNotificationCenter.current()
        // 通知の設定
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                print("通知許可された")
            } else {
                print("通知拒否された")
            }
        }
    }

    // 選択画面に遷移するボタン
    var toSelectPrefectureViewButton: some View {
        NavigationStack {
            Button {
                mainViewModel.tappedSelectPrefectureButton()
            } label: {
                Label("都道府県を選択", systemImage: "list.bullet")
            }
            .mainViewButtonModifier(width: buttonWidth)
        }
        .navigationDestination(isPresented: $mainViewModel.isSelectPrefectureButtonTapped) {
            SelectView()
        }
    }
    // 詳細画面に遷移するボタン
    var toDetailViewButton: some View {
        NavigationStack {
            Button {
                Task {
                    mainViewModel.tappedGetLocationButton()
                }
                
            } label: {
                Label("現在地を取得", systemImage: "location")
            }
            .mainViewButtonModifier(width: buttonWidth)
        }
        //モーダル遷移
        .sheet(isPresented: $mainViewModel.isDisplayDetailView) {
            DetailView()
        }
    }

    //ナビゲーションバーに表示する通知ボタン
    var notificationButton: some View {
        Button {
            mainViewModel.tappedNotificationButton()
        } label: {
            Image(systemName: mainViewModel.notificationImageName())
                .tint(.yellow)
        }
        .releaseNotificationAlertModifier(isPresented: $mainViewModel.isPresentedReleaseNotificationAlert, okClosure: {
            mainViewModel.tappedReleaseOkButton()
        })
        .reserveNotificationAlertModifier(isPresented: $mainViewModel.isPresentedReserveNotificationAlert, okClosure: {
            mainViewModel.tappedReserveOkButton()
        })
        .doneReleaseNotificationAlertModifier(isPresented: $mainViewModel.isPresentedDoneReleaseNotificationAlert)
        .doneReserveNotificationAlertModifier(isPresented: $mainViewModel.isPresentedDoneReserveNotificationAlert)
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
            VStack(spacing: 50) {
                toSelectPrefectureViewButton
                toDetailViewButton
            }
        }

        .navigationTitle(Text("Home"))
        .navigationBarTitleDisplayMode(.inline)
        // 戻るボタンを非表示
        .navigationBarBackButtonHidden()
        .toolbar() {
            ToolbarItem(placement: .navigationBarTrailing) {
                notificationButton
            }
        }
        // 位置情報取得不可時のアラート
        .notGetLocationAlertModifier(isPresented: $mainViewModel.isDisplayNotGetLocDialog)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
