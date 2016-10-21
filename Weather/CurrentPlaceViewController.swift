//
//  CurrentPlaceViewController.swift
//  Weather
//
//  Created by Vladimir on 17.10.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import UIKit

class CurrentPlaseViewController: UIViewController {
    
    var dataModel: WeatherModel!
    
    var currentForecast:Forecast?{
        didSet{
            updateUI()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        currentForecast = updateForecast()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func updateUI(){
        
    }
    
    func updateForecast() -> Forecast?{
        dataModel.updateCurrentForecast()
        return dataModel.currentForecast
        
    }
    
    


}

