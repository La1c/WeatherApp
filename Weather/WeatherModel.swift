//
//  WeatherModel.swift
//  Weather
//
//  Created by Vladimir on 21.10.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import UIKit
import Keys

class WeatherModel{
    
    var currentForecast:Forecast?
    var homeForecast:Forecast?
    let picsDictionary: [String:UIImage] = [
        "01d":#imageLiteral(resourceName: "Sunny"),
        "01n":#imageLiteral(resourceName: "Clear"),
        "02d":#imageLiteral(resourceName: "PartlyCloudyDay"),
        "02n":#imageLiteral(resourceName: "PartlyCloudyNight"),
        "03d":#imageLiteral(resourceName: "Cloudy"),
        "03n":#imageLiteral(resourceName: "Cloudy"),
        "04d":#imageLiteral(resourceName: "ScatteredClouds"),
        "04n":#imageLiteral(resourceName: "ScatteredClouds"),
        "09d":#imageLiteral(resourceName: "ModRain"),
        "09n":#imageLiteral(resourceName: "ModRain"),
        "10d":#imageLiteral(resourceName: "IsoRainSwrsDay"),
        "10n":#imageLiteral(resourceName: "IsoRainSwrsNight"),
        "11d":#imageLiteral(resourceName: "CloudRainThunder"),
        "11n":#imageLiteral(resourceName: "CloudRainThunder"),
        "13d":#imageLiteral(resourceName: "OccLightSnow"),
        "13n":#imageLiteral(resourceName: "OccLightSnow"),
        "50d":#imageLiteral(resourceName: "Mist"),
        "50n":#imageLiteral(resourceName: "Mist")
    ]
    
    
    init() {
        updateCurrentForecast()
        updateHomeForecast()
    }
    
    
    func updateCurrentForecast(){
    }
    
    func updateHomeForecast(){
        
    }

}
