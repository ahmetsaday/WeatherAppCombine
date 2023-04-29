//
//  BaseRequest.swift
//  WeatherApp
//
//  Created by Saday on 28.04.2023.
//

import Foundation
import Combine

enum NetworkError: Error, Equatable {
    case serverError(code:Int, error: String)
    case clientError(code:Int, error: String)
    case invalidJSON(_ error: String)
    case HTTPURLResponseTypeError(_ error: String)
}

class BaseRequest<T:Decodable>: Request {
    
    //MARK: Properties
    var baseURLString: String = "api.openweathermap.org"
    var path: String = "/data/2.5/weather"
    var method: HTTPMethod = .get
    var requestTimeOut: Float = 30
    var parameters: [URLQueryItem]
    var allHTTPHeaderFields: [String : String]
     
    var httpBody: Data?
    
    init() {
        parameters = [URLQueryItem(name: "appid", value: AppConstants.apiKey)]
        allHTTPHeaderFields = [:]
    }
    
    //MARK: Methods
    func getURLRequest() -> URLRequest? {
        guard let url = getURL() else {
            print("URL not found")
            return nil
        }
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = allHTTPHeaderFields
        request.httpBody = httpBody
        
        return request
    }
}

//MARK: Network Call
extension BaseRequest {
    func call() -> AnyPublisher<T,NetworkError> {
        let sessionConfing = URLSessionConfiguration.default
        sessionConfing.timeoutIntervalForRequest = TimeInterval(self.requestTimeOut)
        
        guard let request = getURLRequest() else {
            return Empty().eraseToAnyPublisher()
        }
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { output in
                guard output.response is HTTPURLResponse  else {
                    throw NetworkError.HTTPURLResponseTypeError("Response type is no HTTPURLResponse")
                }
                
                if let httpResponse = output.response as? HTTPURLResponse {
                    let status = httpResponse.statusCode
                    
                    switch status {
                    case 200...299:
                        break
                    case 400...499:
                        throw NetworkError.clientError(code: status, error: "Client Error")
                    case 500...600:
                        throw NetworkError.serverError(code: status, error: "Server Error")
                    default:
                        throw NetworkError.serverError(code: 0, error: "server error")
                    }
                }

                return output.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError({ error in
                NetworkError.invalidJSON(String(describing: error))
            })
            .eraseToAnyPublisher()
    }
}

