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
    private var settingTimeViewWidth = UIScreen.main.bounds.width * 0.8
    private var settingTimeViewHeight = UIScreen.main.bounds.height * 0.25
    private let settingTimeViewColor = Color(uiColor: .darkGray)
    // 親Viewとする
    @ObservedObject var requestParameter = RequestParameter()

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
                    requestParameter.isFromSelectView = false
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
            // 子Viewに渡す
                .environmentObject(requestParameter)
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
        .notPermissionNotificationAlertModifier(isPresented: $mainViewModel.isNotNotificationAlert)
        .releaseNotificationAlertModifier(isPresented: $mainViewModel.isPresentedReleaseNotificationAlert, okClosure: {
            mainViewModel.tappedReleaseOkButton()
        })
        .reserveNotificationAlertModifier(isPresented: $mainViewModel.isPresentedReserveNotificationAlert, notificationTime: $mainViewModel.notificationTime, okClosure: {
            mainViewModel.isSettingTime = true
        })
        .doneReleaseNotificationAlertModifier(isPresented: $mainViewModel.isPresentedDoneReleaseNotificationAlert)
        .doneReserveNotificationAlertModifier(isPresented: $mainViewModel.isPresentedDoneReserveNotificationAlert, notificationTimeString: mainViewModel.notificationTimeString())
    }

    //背景色
    var backgroundView: some View {
        // 画面いっぱいの背景色（グラデーション）
        LinearGradient(gradient: Gradient(colors: [.cyan, .white]), startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
    }
    /// buttonに使用する一部の枠線用
    var partOfBorder: some View {
        Rectangle()
            .foregroundColor(Color(uiColor: .lightGray))
    }
    /// 通知時間の設定画面（アラートに実装不可能なため）
    var settingTimeView: some View {
        ZStack {
            settingTimeViewColor
            VStack(spacing: 0) {
                Text("通知を設定したい時間を選択")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                Spacer()
                DatePicker("時間を選択", selection: $mainViewModel.notificationTime, displayedComponents: .hourAndMinute)
                    .scaleEffect(1.5)
                    .tint(.white)
                    .labelsHidden()
                // Buttonを下部に揃える
                Spacer()
                // 上線
                partOfBorder
                    .frame(width: settingTimeViewWidth, height: 0.5)
                HStack(spacing: 0) {
                    Button("キャンセル") {
                        mainViewModel.tappedReserveCancelButton()
                    }
                    .padding(.vertical)
                    .frame(width: settingTimeViewWidth / 2, height: settingTimeViewHeight / 4)
                    .background(settingTimeViewColor)
                    partOfBorder
                        .frame(width: 0.5, height: settingTimeViewHeight / 4)
                    Button("設定") {
                        mainViewModel.tappedReserveOkButton()
                    }
                    .padding(.vertical)
                    .frame(width: settingTimeViewWidth / 2, height: settingTimeViewHeight / 4)
                    .background(settingTimeViewColor)
                }
            }
        }
        .frame(width: settingTimeViewWidth, height: settingTimeViewHeight)
        // 背景だけ角丸にすることで、実際のアラートっぽくできる！！！！！
        .cornerRadius(30)
    }

    var body: some View {
        ZStack {
            backgroundView
            VStack(spacing: 50) {
                toSelectPrefectureViewButton
                toDetailViewButton
            }
            if mainViewModel.isSettingTime {
                settingTimeView
            }
        }
        .onAppear() {
            // アプリ起動時に位置情報許諾（App使用中の許可）ダイアログの表示
            LocationClient.shared.requestAuthorization()
        }
        .navigationTitle(Text("Home"))
        .navigationBarTitleDisplayMode(.inline)
        // 戻るボタンを非表示
        .navigationBarBackButtonHidden()
        .toolbar() {
            ToolbarItem(placement: .navigationBarTrailing) {
                notificationButton
                // 時間設定中も押せてしまうので、阻止するために
                    .disabled(mainViewModel.isSettingTime)
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
