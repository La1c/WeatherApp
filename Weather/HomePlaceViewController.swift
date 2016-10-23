//
//  HomePlaceViewController.swift
//  Weather
//
//  Created by Vladimir on 17.10.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import UIKit

class HomePlaceViewController: UIViewController {

    @IBOutlet weak var homeWeatherNameLabel: UILabel!
    @IBOutlet weak var eveningTemperatureLabel: UILabel!
    @IBOutlet weak var updateStatusLabel: UILabel!
    @IBOutlet weak var nightTemperatureLabel: UILabel!
    @IBOutlet weak var dayTemperatureLabel: UILabel!
    @IBOutlet weak var morningTemperatureLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var homeTownNameLabel: UILabel!
    var dataModel: WeatherModel!
    
    //update UI when Forecast is updated
    var homeForecast:Forecast?{
        didSet{
            updateUI()
        }
    }
    
    var homeDailyForecast:Forecast?{
        didSet{
            updateDailyUI()
        }
    }

    
    @IBAction func refreshButtonPressed(_ sender: UIButton) {
         updateForecast()
    }
    
    func updateForecast(){
        dataModel.updateHomeForecast()
        dataModel.updateHomeForecastForADay()
    }
    
    
    func updateDailyUI(){
        if let dayTemp = homeDailyForecast?.dayTemperature{
            dayTemperatureLabel.text =  "\(dayTemp > 0 ? "+" : "")\(round(dayTemp))˚"
        }
        
        if let mornTemp = homeDailyForecast?.morningTemperature{
            morningTemperatureLabel.text =  "\(mornTemp > 0 ? "+" : "")\(round(mornTemp))˚"
        }
        
        if let eveTemp = homeDailyForecast?.eveTemperature{
            eveningTemperatureLabel.text =  "\(eveTemp > 0 ? "+" : "")\(round(eveTemp))˚"
        }
        
        if let nightTemp = homeDailyForecast?.nightTemperature{
            nightTemperatureLabel.text =  "\(nightTemp > 0 ? "+" : "")\(round(nightTemp))˚"
        }
    }
    
    func updateUI(){
        homeTownNameLabel.text = homeForecast?.cityName
        if let temperature = homeForecast?.currentTemperature{
            currentTemperatureLabel.text = "\(temperature > 0 ? "+" : "")\(round(temperature))˚C"
        }
        
        if let maxTemp = homeForecast?.maxTemperature{
            maxTemperatureLabel.text = "\(maxTemp > 0 ? "+" : "")\(round(maxTemp))˚C"
        }
        
        if let minTemp = homeForecast?.minTemperature{
            minTemperatureLabel.text = "\(minTemp > 0 ? "+" : "")\(round(minTemp))˚C"
        }
        
        if let humidity = homeForecast?.humidity{
            humidityLabel.text = "\(humidity)%"
        }
        
        if let pressure = homeForecast?.pressure{
            pressureLabel.text = "\(round(pressure * 0.750062))"
        }
        
        currentWeatherImage.image = dataModel.picsDictionary[homeForecast?.imageName ?? "01d"]
        homeWeatherNameLabel.text = homeForecast?.weatherName
        updateStatusLabel.text = "Updated: " + (formatDate(from: homeForecast?.timestamp) ?? "Just Now")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(HomePlaceViewController.heardNotification),
                                               name: NSNotification.Name(rawValue: homeWeatherNotificationKey),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(HomePlaceViewController.heardDailyNotification),
                                               name: NSNotification.Name(rawValue: homeDailyWeatherNotificationKey),
                                               object: nil)

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateForecast()
    }
    
    
    func heardNotification(){
        self.homeForecast = dataModel.homeForecast
    }
    
    func heardDailyNotification(){
        self.homeDailyForecast = dataModel.homeDayForecast
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension HomePlaceViewController{
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


