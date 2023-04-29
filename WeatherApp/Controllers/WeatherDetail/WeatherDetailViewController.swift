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
    
    var subsriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        
        
        WeatherDetailRequest(lat: "44.34", lon: "10.99").call()
            .sink(receiveCompletion: { print("complation \($0)") }, receiveValue: { print("value: \($0.name)") })
            .store(in: &subsriptions)
    }
    
    //MARK: BaseViewController Methods
    func bind() {
        let viewModel = WeatherDetailViewModel()
        
        viewModel.$cityName.assign(to: \.text!, on: cityNameLabel)
            .store(in: &subsriptions)
        viewModel.$cityTemp
            .map { String($0) }
            .assign(to: \.text!, on: cityTempLabel)
            .store(in: &subsriptions)
    }
}
