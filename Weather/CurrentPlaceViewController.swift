//
//  CurrentPlaceViewController.swift
//  Weather
//
//  Created by Vladimir on 17.10.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import UIKit

class CurrentPlaceViewController: UIViewController {
    
    @IBOutlet weak var morningTemperatureLabel: UILabel!
    @IBOutlet weak var eveningTemperatureLabel: UILabel!
    @IBOutlet weak var nightTemperatureLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var dayTemperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var currentCityNameLabel: UILabel!
    @IBOutlet weak var weatherNameLabel: UILabel!
    @IBOutlet weak var updateStatusLabel: UILabel!
    @IBOutlet weak var currentWeatherImageView: UIImageView!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var currentTrafficLevelLabel: UILabel!
    @IBOutlet weak var maxTemperatureLable: UILabel!
    
    var dataModel: WeatherModel!
    
    //update UI when Forecast is updated
    var currentForecast:Forecast?{
        didSet{
            updateUI()
        }
    }
    
    var currentDailyForecast:Forecast?{
        didSet{
            updateDailyUI()
        }
    }

    @IBAction func updateButtonPressed(_ sender: UIButton) {
        updateForecast()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Listening for changes in the model
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(CurrentPlaceViewController.heardNotification),
                                               name: NSNotification.Name(rawValue: currentWeatherNotificationKey),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(CurrentPlaceViewController.heardDailyNotification),
                                               name: NSNotification.Name(rawValue: currentDailyWeatherNotificationKey),
                                               object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //update Forecast when recieved new data
    func heardNotification(){
        self.currentForecast = dataModel.currentForecast
    }
    
    func heardDailyNotification(){
        self.currentDailyForecast = dataModel.currentDayForecast
    }
    
    
    func updateUI(){
        currentCityNameLabel.text = currentForecast?.cityName
        if let temperature = currentForecast?.currentTemperature{
             currentTemperatureLabel.text = "\(temperature > 0 ? "+" : "")\(round(temperature))˚C"
        }
        
        if let maxTemp = currentForecast?.maxTemperature{
            maxTemperatureLable.text = "\(maxTemp > 0 ? "+" : "")\(round(maxTemp))˚C"
        }
        
        if let minTemp = currentForecast?.minTemperature{
            minTemperatureLabel.text = "\(minTemp > 0 ? "+" : "")\(round(minTemp))˚C"
        }
        
        if let humidity = currentForecast?.humidity{
            humidityLabel.text = "\(humidity)%"
        }
        
        if let pressure = currentForecast?.pressure{
            pressureLabel.text = "\(round(pressure * 0.750062))"
        }
        
        currentWeatherImageView.image = dataModel.picsDictionary[currentForecast?.imageName ?? "01d"]
        weatherNameLabel.text = currentForecast?.weatherName
        updateStatusLabel.text = "Updated: " + (formatDate(from: currentForecast?.timestamp) ?? "Just Now")
    }
    
    func updateDailyUI(){
        if let dayTemp = currentDailyForecast?.dayTemperature{
            dayTemperatureLabel.text =  "\(dayTemp > 0 ? "+" : "")\(round(dayTemp))˚"
        }
        
        if let mornTemp = currentDailyForecast?.morningTemperature{
            morningTemperatureLabel.text =  "\(mornTemp > 0 ? "+" : "")\(round(mornTemp))˚"
        }
        
        if let eveTemp = currentDailyForecast?.eveTemperature{
            eveningTemperatureLabel.text =  "\(eveTemp > 0 ? "+" : "")\(round(eveTemp))˚"
        }
        
        if let nightTemp = currentDailyForecast?.nightTemperature{
            nightTemperatureLabel.text =  "\(nightTemp > 0 ? "+" : "")\(round(nightTemp))˚"
        }
    }
    
    func updateForecast(){
        dataModel.updateCurrentForecast()
        dataModel.updateCurrentForecastForADay()
    }
}

// MARK: Format Data
extension CurrentPlaceViewController{
    func formatDate(from utc: Double?) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.timeZone = TimeZone.current
        
        if let time = utc{
            return dateFormatter.string(from: Date(timeIntervalSince1970: time))
        }
        return nil
    }
}

