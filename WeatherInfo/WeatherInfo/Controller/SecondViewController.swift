//
//  SecondViewController.swift
//  WeatherInfo
//
//  Created by 김동규 on 2022/01/16.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    let cellIdentifier: String = "City Cell"
    var countryName: String?
    var assetName: String?
    var cities: [City] = []
    
    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Protocol Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: CityTableViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! CityTableViewCell
        
        let city: City = self.cities[indexPath.row]
        
        cell.cityNameLabel.text = city.cityName
        cell.temperatureLabel.text = city.temperatureText
        cell.rainfallLabel.text = city.rainfallText
        cell.weatherImage.image = UIImage(named: city.wheather)
        
        if city.isHighRainfall {
            cell.temperatureLabel.textColor = .black
            cell.rainfallLabel.textColor = .orange
        } else {
            cell.temperatureLabel.textColor = .blue
            cell.rainfallLabel.textColor = .black
        }
        
        return cell
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nextViewContriller: ThirdViewController = segue.destination as? ThirdViewController else {
            return
        }
        
        if let indexPath = tableView.indexPathForSelectedRow {
            let city: City = self.cities[indexPath.row]
            nextViewContriller.image = UIImage(named: city.wheather)
            nextViewContriller.cityName = city.cityName
            nextViewContriller.wheather = city.wheatherKorean
            nextViewContriller.temprature = city.temperatureText
            nextViewContriller.rainfall = city.rainfallText
            nextViewContriller.isRain = city.isHighRainfall
        }

        nextViewContriller.countryName = self.countryName
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.countryName
        if let navBar = self.navigationController?.navigationBar {
            navBar.topItem?.backButtonTitle = "세계 날씨"
        }
        
        let jsonDecoder: JSONDecoder = JSONDecoder()
        if let assetName = assetName {
            guard let dataAsset: NSDataAsset = NSDataAsset(name: assetName) else {
                return
            }
            
            do {
                self.cities = try jsonDecoder.decode([City].self, from: dataAsset.data)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        self.tableView.reloadData()
    }
}
