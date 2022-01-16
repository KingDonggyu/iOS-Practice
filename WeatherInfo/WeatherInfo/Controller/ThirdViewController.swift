//
//  ThirdViewController.swift
//  WeatherInfo
//
//  Created by 김동규 on 2022/01/16.
//

import UIKit

class ThirdViewController: UIViewController {
    
    var image: UIImage?
    var countryName: String?
    var cityName: String?
    var wheather: String?
    var temprature: String?
    var rainfall: String?
    var isRain: Bool?
    
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var rainfallLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let navBar = self.navigationController?.navigationBar {
            navBar.topItem?.backButtonTitle = countryName
        }

        if let image = self.image, let cityName = self.cityName, let wheather = self.wheather,
           let temprature = self.temprature, let rainfall = self.rainfall, let isRain = self.isRain {
            
            self.title = cityName
            self.weatherImage.image = image
            self.weatherLabel.text = wheather
            self.temperatureLabel.text = temprature
            self.rainfallLabel.text = rainfall
            
            if isRain {
                self.rainfallLabel.textColor = .orange
            } else {
                self.temperatureLabel.textColor = .blue
            }
        }
        
    }
}
