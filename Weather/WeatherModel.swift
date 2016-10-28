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
import CoreLocation

let currentWeatherNotificationKey = "currentWeatherKey"
let currentDailyWeatherNotificationKey = "currentWeatherForDayKey"
let homeDailyWeatherNotificationKey = "homeWeatherForDayKey"
let homeWeatherNotificationKey = "homeWeatherKey"

class WeatherModel: NSObject, CLLocationManagerDelegate{
    
    var currentForecast:Forecast?
    var currentDayForecast:Forecast?
    var homeForecast:Forecast?
    var homeDayForecast: Forecast?
    var currentLocation:(longtitude: Double, latitude: Double)?
    var homeLocation:(longtitude: Double, latitude: Double)? = (30.315785, 59.939039) //SPb coord
    let keys = WeatherKeys()
    var locationManager: CLLocationManager?
    
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
    
    static let sharedInstance: WeatherModel = {
        let instance = WeatherModel()
        return instance
    }()
    
    
    override init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        currentLocation = getCurrentLocation() 
    }
    
    func getCurrentLocation() -> (longtitude:Double, latitude:Double)?{
        locationManager?.requestLocation()
        //Get device location
        //
        if let recentLocation = locationManager?.location?.coordinate{
            return (recentLocation.longitude, recentLocation.latitude)
        }
        return (-122.431297,37.773972) //SF coord
    }
    
    func updateCurrentLocation(){
        self.locationManager?.requestLocation()
        if let recentLocation = self.locationManager?.location?.coordinate{
            self.currentLocation = (recentLocation.longitude, recentLocation.latitude)
        }

    }
    

    func getForecast(for location: (longtitude: Double, latitude: Double),
                     completion:@escaping (_ forecast: Forecast?) -> Void){
        Alamofire.request("http://api.openweathermap.org/data/2.5/weather",
            parameters: ["lat":location.latitude,
                         "lon": location.longtitude,
                         "APPID": keys.openWeatherAPIKey()!,
                         "units":"metric"])
            .responseJSON{response in
            guard response.result.isSuccess else{
                print(response.result.error)
                completion(nil)
                return
            }
            
                let json = JSON(response.result.value!)
                let newTemperature = json["main"]["temp"].double
                let newMaxTemperature = json["main"]["temp_max"].double
                let newMinTemperature = json["main"]["temp_min"].double
                let newHumidity = json["main"]["humidity"].int
                let newPressure = json["main"]["pressure"].double
                let newTimestamp = json["dt"].doubleValue
                let newImageName = json["weather"].arrayValue[0]["icon"].stringValue
                let newWeatherName = json["weather"].arrayValue[0]["main"].stringValue
                let newWeatherDescription = json["weather"].arrayValue[0]["description"].stringValue
                let newCityName = json["name"].stringValue
                let newCountryName = json["sys"]["country"].stringValue
                let newForecast = Forecast(currentWeatherTemperature: newTemperature,
                                           maxTemperature: newMaxTemperature,
                                           minTemperature: newMinTemperature,
                                           humidity: newHumidity,
                                           pressure: newPressure,
                                           timestamp: newTimestamp,
                                           imageName: newImageName,
                                           locationCoordinates: location,
                                           weatherName: newWeatherName,
                                           weathetDescription: newWeatherDescription,
                                           cityName: newCityName,
                                           countryName: newCountryName)
                completion(newForecast)
        }
    }
    
    func getForecastForADay(for location: (longtitude: Double, latitude: Double),
                            completion:@escaping (_ forecast: Forecast?) -> Void){
        Alamofire.request("http://api.openweathermap.org/data/2.5/forecast/daily",
                          parameters: ["lat":location.latitude,
                                       "lon": location.longtitude,
                                       "APPID": keys.openWeatherAPIKey()!,
                                       "units":"metric",
                                       "cnt":1])
            .responseJSON{response in
                guard response.result.isSuccess else{
                    print(response.result.error)
                    return
                }
                
                let json = JSON(response.result.value!)
                let newMorningTemperature = json["list"].arrayValue[0]["temp"]["morn"].double
                let newDayTemperature = json["list"].arrayValue[0]["temp"]["day"].double
                let newEveTemperature = json["list"].arrayValue[0]["temp"]["eve"].double
                let newNightTemperature = json["list"].arrayValue[0]["temp"]["night"].double

                let newDayForecast = Forecast(morningTemperature: newMorningTemperature,
                                              dayTemperature: newDayTemperature,
                                              eveTemperature: newEveTemperature,
                                              nightTemperature: newNightTemperature)
                completion(newDayForecast)
        }
    }
    
     func locationManager(_ location: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = (locations[0].coordinate.longitude, locations[0].coordinate.latitude)
        print("locations = \(locations)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        return super.isEqual(object)
        }
    }
