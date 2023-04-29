//
//  SplashViewController.swift
//  WeatherApp
//
//  Created by Saday on 27.04.2023.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let weatherDetailVC = WeatherDetailViewController.createFromStoryboard()
        weatherDetailVC.modalPresentationStyle = .fullScreen
        self.present(weatherDetailVC, animated: true)
    }

}
