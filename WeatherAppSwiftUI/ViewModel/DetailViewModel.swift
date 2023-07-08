//
//  DetailViewModel.swift
//  WeatherAppSwiftUI
//

//

import SwiftUI
// ViewModel
class DetailViewModel: ObservableObject {
    @Published var chartheiht = UIScreen.main.bounds.height / 3
    
    @Published var sectonCount: Int?
    @Published var cellCount: Int?

}
