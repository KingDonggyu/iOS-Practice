//
//  Country.swift
//  WeatherInfo
//
//  Created by 김동규 on 2022/01/16.
//

/*
 [
       {"korean_name":"한국","asset_name":"kr"},
       {"korean_name":"독일","asset_name":"de"},
       {"korean_name":"이탈리아","asset_name":"it"},
       {"korean_name":"미국","asset_name":"us"},
       {"korean_name":"프랑스","asset_name":"fr"},
       {"korean_name":"일본","asset_name":"jp"}
 ]

*/

import Foundation

struct Country: Codable {
    let name: String
    let assetName: String
    
    var imageName: String {
        return "flag_" + self.assetName
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "korean_name"
        case assetName = "asset_name"
    }
}
