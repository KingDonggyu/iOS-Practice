//
//  CityTableViewCell.swift
//  WeatherInfo
//
//  Created by 김동규 on 2022/01/16.
//

import UIKit

class CityTableViewCell: UITableViewCell {
    
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var rainfallLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
