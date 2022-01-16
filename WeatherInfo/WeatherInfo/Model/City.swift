//
//  Weather.swift
//  WeatherInfo
//
//  Created by 김동규 on 2022/01/16.
//

import Foundation

/*
 {
    "city_name":"서울",
    "state":12,
    "celsius":17.8,
    "rainfall_probability":60
 },
*/

struct City: Codable {
    let cityName: String
    let state: Int
    let celsius: Float
    let rainfall: Int
    
    var wheather: String {
        switch state {
        case 11:
            return "cloudy"
        case 12:
            return "rainy"
        case 13:
            return "snowy"
        default:
            return "sunny"
        }
    }
    
    var wheatherKorean: String {
        switch state {
        case 11:
            return "흐림"
        case 12:
            return "비"
        case 13:
            return "눈"
        default:
            return "맑음"
        }
    }
    
    var temperatureText: String {
        let digit: Float = pow(10, 1)
        let fahrenheit: Float = roundf((celsius * 9/5 + 32) * digit) / digit
        return "섭씨 \(celsius)도 / 화씨 \(fahrenheit)도"
    }
    
    var rainfallText: String {
        return "강수확률 \(rainfall)%"
    }
    
    var isHighRainfall: Bool {
        if rainfall > 50 {
            return true
        }
        return false
    }
    
    enum CodingKeys: String, CodingKey {
        case cityName = "city_name"
        case state, celsius
        case rainfall = "rainfall_probability"
    }
}
