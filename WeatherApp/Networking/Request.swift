//
//  Request.swift
//  WeatherApp
//
//  Created by Saday on 28.04.2023.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

public protocol Request {
    var baseURLString: String { get set}
    var path: String { get set }
    var parameters: [URLQueryItem] { get set }
    var allHTTPHeaderFields: [String : String] { get set}
    var method: HTTPMethod { get set}
    
    func getURL() -> URL?
}

extension Request {
    
//  https://api.openweathermap.org/data/2.5/weather?lat=44.34&lon=10.99&appid=f067cd16326de083146b42002effa017
    
    func getURL() -> URL? {
        var component = URLComponents()
        component.scheme = "https"
        component.host = baseURLString
        component.path = path
        component.queryItems = parameters
        
        return component.url
    }
}
