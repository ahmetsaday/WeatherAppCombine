//
//  WeatherDetailViewController.swift
//  WeatherApp
//
//  Created by Saday on 27.04.2023.
//

import UIKit
import Combine

class WeatherDetailViewController: UIViewController, BaseViewController {

    //MARK: Properties
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var cityTempLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    
    private var subsriptions = Set<AnyCancellable>()
    private let viewModel = WeatherDetailViewModel()
    private let input: PassthroughSubject<WeatherDetailViewModel.Input, Never> = .init()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        input.send(.viewDidAppear)
    }
    
    func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .fetchWeatherFail(error: let error):
                    self?.cityNameLabel.text = error.localizedDescription
                case .fetchWeatherSucceed(weather: let weather):
                    self?.cityNameLabel.text = weather.cityName
                    self?.cityTempLabel.text = String(weather.cityTemp)
                case .toggleButton(isEnabled: let isEnabled):
                    self?.refreshButton.isEnabled = isEnabled
                }
            }
            .store(in: &subsriptions)
    }
    
    
    
    @IBAction func refreshButtonTapped(_ sender: UIButton) {
        input.send(.refreshButtonDidTap)
    }
    
    
}
