//
//  Forecast.swift
//  Weather
//
//  Created by Vladimir on 21.10.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import Foundation

class Forecast{
    let currentCoord:(longtitude: Double, latitude: Double)?
    let currentTemperature: Double?
    let maxTemperature: Double?
    let minTemperature: Double?
    let precipitationProbability: Double?
    let timestamp: Double
    let imageName: String
    let weatherName: String
    let weathetDescription: String
    let cityName: String
    let countryName: String
    
    
    init(currentWeatherTemperature: Double?, maxTemperature:Double?, minTemperature:Double?, precipitationProbability: Double?, timestamp: Double, imageName: String, locationCoordinates: (Double, Double)?, weatherName:String, weathetDescription: String, cityName: String, countryName: String) {
        self.currentTemperature = currentWeatherTemperature
        self.maxTemperature = maxTemperature
        self.minTemperature = minTemperature
        self.precipitationProbability = precipitationProbability
        self.timestamp = timestamp
        self.imageName = imageName
        self.currentCoord = locationCoordinates
        self.weatherName = weatherName
        self.weathetDescription = weathetDescription
        self.cityName = cityName
        self.countryName = countryName
    }
}
