//
//  WeatherDetailViewModel.swift
//  WeatherApp
//
//  Created by Saday on 27.04.2023.
//

import Foundation
import Combine

class WeatherDetailViewModel {
    
    enum Input {
        case viewDidAppear
        case refreshButtonDidTap
    }
    
    enum Output {
        case fetchWeatherFail(error: NetworkError)
        case fetchWeatherSucceed(weather:Weather)
        case toggleButton(isEnabled: Bool)
    }
    
    private let output: PassthroughSubject<Output, Never> = .init()
    private var subscription = Set<AnyCancellable>()
    
    func transform(input: AnyPublisher<Input,Never>) -> AnyPublisher<Output,Never> {
        input.sink { [weak self] event in
            switch event {
                
            case .viewDidAppear, .refreshButtonDidTap:
                self?.handleGetWeather()
            }
        }.store(in: &subscription)
        
        return output.eraseToAnyPublisher()
    }
    
    private func handleGetWeather() {
        output.send(.toggleButton(isEnabled: false))
        WeatherDetailRequest(lat: "44.34", lon: "10.99").call()
            .sink { [weak self] complation in
                self?.output.send(.toggleButton(isEnabled: true))
                
                if case .failure(let error) = complation {
                    self?.output.send(.fetchWeatherFail(error: error))
                }
                
            } receiveValue: { [weak self] weatherDetailResponse in
                let weather = Weather(cityName: weatherDetailResponse.name, cityTemp: 30)
                self?.output.send(.fetchWeatherSucceed(weather: weather))
            }.store(in: &subscription)

    }
}
