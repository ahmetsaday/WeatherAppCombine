//
//  WeatherDetailViewModel.swift
//  WeatherApp
//
//  Created by Saday on 27.04.2023.
//

import Foundation
import Combine

class WeatherDetailViewModel: ObservableObject {
    @Published private(set) var cityName: String
    @Published private(set) var cityTemp: Int
    
    var subsriptions =  Set<AnyCancellable>()
    
    let weather = Weather(cityName: "Istanbul", cityTemp: 24)
    
    init() {
        self.cityName = weather.cityName
        self.cityTemp = weather.cityTemp



    }
    
    
//    WeatherDetailRequest().call()
//        .sink {completion in
//
//        } { value in
//
//        }
    
    
}
