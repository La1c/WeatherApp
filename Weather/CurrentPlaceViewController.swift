//
//  CurrentPlaceViewController.swift
//  Weather
//
//  Created by Vladimir on 17.10.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import UIKit
import CoreLocation

class CurrentPlaceViewController: UIViewController, WeatherModelDelegate, SettingDelegate {
    
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
    @IBOutlet weak var updateButton: UIButton!
    
    var isRotating = false
    var shouldStopRotating = false
    
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
        updateButton.startRotating()
        updateForecast()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        dataModel = WeatherModel.sharedInstance
        dataModel.delegate = self
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            dataModel.locationManager?.requestWhenInUseAuthorization()
            if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
                dataModel.updateCurrentLocation()
            }
        case .authorizedWhenInUse:
            print("Permission granted")
            dataModel.updateCurrentLocation()
        default:
            print("No permission")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSettings"{
            let vc = segue.destination as! SettingsViewController
            vc.backDelegate = self
        }
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
    
    func weatherModelDidUpdate(location: (longtitude: Double, latitude: Double)) {
        dataModel.getForecast(for: location,
                              completion: {self.currentForecast = $0})
        dataModel.getForecastForADay(for: location,
                                     completion: {self.currentDailyForecast = $0})
        self.updateButton.stopRotating()
    }
    
    func updateForecast(){
        dataModel.updateCurrentLocation()
    }
    
    func userFinishedChangingSettings() {
        dismiss(animated: true, completion: nil)
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

// MARK: Animation
extension UIView {
    func startRotating(duration: Double = 1) {
        let kAnimationKey = "rotation"
        if self.layer.animation(forKey: kAnimationKey) == nil {
            let animate = CABasicAnimation(keyPath: "transform.rotation")
            animate.duration = duration
            animate.repeatCount = Float.infinity
            animate.fromValue = 0.0
            animate.toValue = Float(-M_PI * 2.0)
            self.layer.add(animate, forKey: kAnimationKey)
        }
    }
    func stopRotating() {
        let kAnimationKey = "rotation"
        
        if self.layer.animation(forKey: kAnimationKey) != nil {
            self.layer.removeAnimation(forKey: kAnimationKey)
        }
    }
}

