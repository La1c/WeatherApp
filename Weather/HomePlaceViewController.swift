//
//  HomePlaceViewController.swift
//  Weather
//
//  Created by Vladimir on 17.10.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import UIKit

class HomePlaceViewController: UIViewController {

    @IBOutlet weak var day5MaxLabel: UILabel!
    @IBOutlet weak var day4MaxLabel: UILabel!
    @IBOutlet weak var day3MaxLabel: UILabel!
    @IBOutlet weak var day2MaxLabel: UILabel!
    @IBOutlet weak var day1MaxLabel: UILabel!
    @IBOutlet weak var day5MinLabel: UILabel!
    @IBOutlet weak var day4MinLabel: UILabel!
    @IBOutlet weak var day3MinLabel: UILabel!
    @IBOutlet weak var day2MinLabel: UILabel!
    @IBOutlet weak var day1MinLabel: UILabel!
    @IBOutlet weak var day5Image: UIImageView!
    @IBOutlet weak var day4Image: UIImageView!
    @IBOutlet weak var day3Image: UIImageView!
    @IBOutlet weak var day2Image: UIImageView!
    @IBOutlet weak var day1Image: UIImageView!
    @IBOutlet weak var day5Label: UILabel!
    @IBOutlet weak var day4Label: UILabel!
    @IBOutlet weak var day3Label: UILabel!
    @IBOutlet weak var day2Label: UILabel!
    @IBOutlet weak var day1Label: UILabel!
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
                                     cnt: 5,
                                     completion: {self.homeDailyForecast = $0})
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSettings"{
            let vc = segue.destination as! SettingsViewController
            vc.backDelegate = self
        }
    }
    
    
    func configureDayUI(dayForecast: Forecast?,
                        dayLabel: UILabel,
                        iMView: UIImageView,
                        minLabel: UILabel,
                        maxLabel: UILabel){
        
        if let maxTemp = dayForecast?.maxTemperature{
            maxLabel.text = "\(maxTemp > 0 ? "+" : "")\(round(maxTemp))˚C"
        }
        
        if let minTemp = dayForecast?.minTemperature{
            minLabel.text = "\(minTemp > 0 ? "+" : "")\(round(minTemp))˚C"
        }
        
        iMView.image = dataModel.picsDictionary[dayForecast?.imageName ?? "01d"]
        dayLabel.text = formatDayOfTheWeek(from: dayForecast?.timestamp)
    }
 
    func updateDailyUI(){
 
        configureDayUI(dayForecast: homeDailyForecast[0], dayLabel: day1Label, iMView: day1Image, minLabel: day1MinLabel, maxLabel: day1MaxLabel)
        configureDayUI(dayForecast: homeDailyForecast[1], dayLabel: day2Label, iMView: day2Image, minLabel: day2MinLabel, maxLabel: day2MaxLabel)
        configureDayUI(dayForecast: homeDailyForecast[2], dayLabel: day3Label, iMView: day3Image, minLabel: day3MinLabel, maxLabel: day3MaxLabel)
        configureDayUI(dayForecast: homeDailyForecast[3], dayLabel: day4Label, iMView: day4Image, minLabel: day4MinLabel, maxLabel: day4MaxLabel)
        configureDayUI(dayForecast: homeDailyForecast[4], dayLabel: day5Label, iMView: day5Image, minLabel: day5MinLabel, maxLabel: day5MaxLabel)
         self.updateButton.stopRotating()
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

extension HomePlaceViewController{
    func formatDayOfTheWeek(from utc: Double?) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        dateFormatter.timeZone = TimeZone.current
        
        if let time = utc{
            return dateFormatter.string(from: Date(timeIntervalSince1970: time))
        }
        return nil
    }
}

extension HomePlaceViewController : SettingDelegate{
    func userFinishedChangingSettings(coordinates: (longtitude: Double, latitude: Double)?, geolocationAuthed: Bool?) {
        dataModel.updateHomeLocation(newCoord: coordinates)
        updateForecast()
        dismiss(animated: true, completion: nil)
    }
}


