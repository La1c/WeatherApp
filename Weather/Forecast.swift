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
    let morningTemperature: Double?
    let dayTemperature: Double?
    let eveTemperature: Double?
    let nightTemperature: Double?
    let humidity: Int?
    let pressure: Double?
    let timestamp: Double
    let imageName: String
    let weatherName: String
    let weathetDescription: String
    let cityName: String
    let countryName: String
    
    
    
    init(currentWeatherTemperature: Double? = nil,
         maxTemperature:Double? = nil,
         minTemperature: Double? = nil,
         morningTemperature: Double? = nil,
         dayTemperature: Double? = nil,
         eveTemperature: Double? = nil,
         nightTemperature: Double? = nil,
         humidity: Int? = nil,
         pressure: Double? = nil,
         timestamp: Double = Date.init().timeIntervalSince1970,
         imageName: String = "01d",
         locationCoordinates: (Double, Double)? = nil,
         weatherName:String = "Clear",
         weathetDescription: String = "Sunny",
         cityName: String = "San-Francisco",
         countryName: String = "US"){
        
        self.currentTemperature = currentWeatherTemperature
        self.maxTemperature = maxTemperature
        self.minTemperature = minTemperature
        self.morningTemperature = morningTemperature
        self.dayTemperature = dayTemperature
        self.eveTemperature = eveTemperature
        self.nightTemperature = nightTemperature
        self.humidity = humidity
        self.pressure = pressure
        self.timestamp = timestamp
        self.imageName = imageName
        self.currentCoord = locationCoordinates
        self.weatherName = weatherName
        self.weathetDescription = weathetDescription
        self.cityName = cityName
        self.countryName = countryName
    }

}
