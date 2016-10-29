//
//  HomePlaceViewController.swift
//  Weather
//
//  Created by Vladimir on 17.10.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import UIKit

class HomePlaceViewController: UIViewController, SettingDelegate {

    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var homeWeatherNameLabel: UILabel!
    @IBOutlet weak var updateStatusLabel: UILabel!
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
    
    var homeDailyForecast:[Forecast?] = []{
        didSet{
            updateDailyUI()
        }
    }

    
    @IBAction func refreshButtonPressed(_ sender: UIButton) {
         updateButton.startRotating()
         updateForecast()
    }
    
    func updateForecast(){
        dataModel.getForecast(for: dataModel.homeLocation!,
                              completion: {self.homeForecast = $0})
      dataModel.getForecastForDays(for: dataModel.homeLocation!,
                                     completion: {self.homeDailyForecast = $0})
    }
    
    
    func updateDailyUI(){
  /*      if let dayTemp = homeDailyForecast?.dayTemperature{
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
 */
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
        self.dataModel = WeatherModel.sharedInstance
        dataModel.getForecast(for: dataModel.homeLocation!, completion: {self.homeForecast = $0})
        dataModel.getForecastForDays(for: dataModel.homeLocation!, cnt: 5, completion: {self.homeDailyForecast = $0})
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func userFinishedChangingSettings() {
        dismiss(animated: true, completion: nil)
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


