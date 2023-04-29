//
//  WeatherDetailRequest.swift
//  WeatherApp
//
//  Created by Saday on 28.04.2023.
//

import Foundation

class WeatherDetailRequest: BaseRequest<WeatherDetailResponse> {
    let lat: String
    let lon: String
    
    init(lat: String, lon: String) {
        self.lat = lat
        self.lon = lon
        
        super.init()
        self.parameters.append(URLQueryItem(name: "lat", value: lat))
        self.parameters.append(URLQueryItem(name: "lon", value: lon))
    }
}

struct WeatherDetailResponse: Decodable {
    let name: String
}
