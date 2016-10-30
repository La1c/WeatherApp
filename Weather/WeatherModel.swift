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



protocol WeatherModelDelegate: class{
    func weatherModelDidUpdate(location: (longtitude: Double, latitude: Double))
    func requestPermissonForLocationService()
}

class WeatherModel: NSObject, CLLocationManagerDelegate{
    
    var currentForecast:Forecast?
    var currentDayForecast:Forecast?
    var homeForecast:Forecast?
    var homeDayForecast: Forecast?
    var currentLocation:(longtitude: Double, latitude: Double)?
    var homeLocation:(longtitude: Double, latitude: Double)? = (30.315785, 59.939039) //SPb coord
    let keys = WeatherKeys()
    var locationManager: CLLocationManager?
    
    weak var delegate: WeatherModelDelegate?
    
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
        updateCurrentLocation()
    }
    
    func updateHomeLocation(newCoord: (longtitude: Double, latitude: Double)?){
        if let newLocation = newCoord{
            homeLocation = newLocation
        }
    }
    
    func updateCurrentLocation(){
        self.locationManager?.requestLocation()
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
    
    func getForecastForDays(for location: (longtitude: Double, latitude: Double),
                            cnt: Int = 1,
                            completion:@escaping (_ forecast: [Forecast?]) -> Void){
        Alamofire.request("http://api.openweathermap.org/data/2.5/forecast/daily",
                          parameters: ["lat":location.latitude,
                                       "lon": location.longtitude,
                                       "APPID": keys.openWeatherAPIKey()!,
                                       "units":"metric",
                                       "cnt":cnt])
            .responseJSON{response in
                guard response.result.isSuccess else{
                    return
                }
                
                var newForecastForDays = [Forecast?]()
                let json = JSON(response.result.value!)
                let days = json["list"].arrayValue
                for day in days{
                    let newImageName = day["weather"].arrayValue[0]["icon"].stringValue
                    let newWeatherName = day["weather"].arrayValue[0]["main"].stringValue
                    let newMorningTemperature = day["temp"]["morn"].double
                    let newDayTemperature = day["temp"]["day"].double
                    let newEveTemperature = day["temp"]["eve"].double
                    let newNightTemperature = day["temp"]["night"].double
                    let newMaxTemperature = day["temp"]["max"].double
                    let newMinTemperature = day["temp"]["min"].double
                    let newTimestamp = day["dt"].doubleValue
                    
                    let newDayForecast = Forecast(maxTemperature: newMaxTemperature,
                                                  minTemperature: newMinTemperature,
                                                  morningTemperature: newMorningTemperature,
                                                  dayTemperature: newDayTemperature,
                                                  eveTemperature: newEveTemperature,
                                                  nightTemperature: newNightTemperature,
                                                  timestamp: newTimestamp,
                                                  imageName: newImageName,
                                                  weatherName: newWeatherName)
                    newForecastForDays.append(newDayForecast)
                }
                completion(newForecastForDays)
        }
    }
    
     func locationManager(_ location: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = (locations[locations.count - 1].coordinate.longitude, locations[locations.count - 1].coordinate.latitude)
        delegate?.weatherModelDidUpdate(location: self.currentLocation!)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager?.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            updateCurrentLocation()
        default:
            delegate?.requestPermissonForLocationService()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        return super.isEqual(object)
        }
    }
