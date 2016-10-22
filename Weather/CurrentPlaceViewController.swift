//
//  CurrentPlaceViewController.swift
//  Weather
//
//  Created by Vladimir on 17.10.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import UIKit

class CurrentPlaceViewController: UIViewController {
    
    @IBOutlet weak var currentCityNameLabel: UILabel!
    @IBOutlet weak var updateStatusLabel: UILabel!
    @IBOutlet weak var currentWeatherImageView: UIImageView!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var currentPrecepitationProbabilityLabel: UILabel!
    @IBOutlet weak var currentTrafficLevelLabel: UILabel!
    @IBOutlet weak var currentPrecepitationProbabilityLevelImageView: UIImageView!
    
    
    var dataModel: WeatherModel!
    
    var currentForecast:Forecast?{
        didSet{
            updateUI()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(CurrentPlaceViewController.heardNotification), name: NSNotification.Name(rawValue: currentWeatherNotificationKey), object: nil)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func heardNotification(){
        self.currentForecast = dataModel.currentForecast
        updateUI()
    }
    
    
    func updateUI(){
        currentCityNameLabel.text = currentForecast?.cityName
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        if let temperature = currentForecast?.currentTemperature{
             currentTemperatureLabel.text = formatter.string(from: temperature as NSNumber)
        }
        currentWeatherImageView.image = dataModel.picsDictionary[currentForecast?.imageName ?? "01d"]
    }
    
    func updateForecast() -> Forecast?{
        dataModel.updateCurrentForecast()
        return dataModel.currentForecast
    }
    
    


}

