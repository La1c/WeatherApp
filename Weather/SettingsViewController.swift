//
//  SettingsViewController.swift
//  Weather
//
//  Created by Vladimir on 28.10.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import UIKit
import CoreLocation

protocol SettingDelegate: class{
    func userFinishedChangingSettings()
}

class SettingsViewController: UIViewController {
    
    weak var backDelegate: SettingDelegate?
    
    @IBOutlet weak var searchButton: UIButton!
    
    
    var homeTown: String {
        
        get {
            if let returnValue = UserDefaults.standard.object(forKey: "Home Town") as? String {
                
                return returnValue
            } else {
                return "Saint-Petersburg"
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "Home Town")
            UserDefaults.standard.synchronize()
        }
    }
    
    var homeTownLocation:(longtitude: Double, latitude: Double){
        get {
            if let lon = UserDefaults.standard.object(forKey: "Town Location Longtitude") as? Double,
                let lat = UserDefaults.standard.object(forKey: "Town Location Latitude") as? Double{
                
                return (lon, lat)
            } else {
                return (30.315785, 59.939039)
            }
        }
        set {
            UserDefaults.standard.set(newValue.longtitude, forKey: "Town Location Longtitude")
            UserDefaults.standard.set(newValue.latitude, forKey: "Town Location Latitude")
            UserDefaults.standard.synchronize()
        }
    }
    
    @IBAction func privacyManagementButtonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(
            title: "Manage Location Access",
            message: "If you want to change your location permissions, feel free to do it from Settings app.",
            preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .default) {(action) in
            if let url = URL(string: UIApplicationOpenSettingsURLString){
                UIApplication.shared.openURL (url)
            }
        }
        alertController.addAction(openAction)
        self.present(alertController, animated: true, completion: nil)
    }

    

    

    @IBAction func backButtonPressed(_ sender: AnyObject) {
        backDelegate?.userFinishedChangingSettings()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        self.view.insertSubview(blurEffectView, at: 0)
        // Do any additional setup after loading the view.
    }

    override func viewWillLayoutSubviews() {
        searchButton.titleLabel?.text = homeTown
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSearch"{
            let searchVC = segue.destination as! SearchViewController
            searchVC.delegate = self
        }
    }
}

extension SettingsViewController: SearchDeletate{
    func userFinishedEdittingHomeLocation(locationName: String, coordinates: (longtitude: Double, latitude: Double)?){
        homeTown = locationName
        searchButton.titleLabel?.text = homeTown
        if let coordinates = coordinates{
             homeTownLocation = coordinates
        }
       
        dismiss(animated: true, completion: nil)
        
    }
    func userCanceledSearch(){
         dismiss(animated: true, completion: nil)
    }
}
