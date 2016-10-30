//
//  SettingsViewController.swift
//  Weather
//
//  Created by Vladimir on 28.10.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import UIKit

protocol SettingDelegate: class{
    func userFinishedChangingSettings(coordinates: (longtitude: Double, latitude: Double)?, geolocationAuthed: Bool?)
}

class SettingsViewController: UIViewController {
    
    weak var backDelegate: SettingDelegate?
    
    @IBOutlet weak var searchButton: UIButton!
    var homeTownLocation:(longtitude: Double, latitude: Double)?
    var geolocationStatus = true
    
    
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
    

    @IBAction func backButtonPressed(_ sender: AnyObject) {
        backDelegate?.userFinishedChangingSettings(coordinates: homeTownLocation, geolocationAuthed: geolocationStatus)
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
        homeTownLocation = coordinates
        dismiss(animated: true, completion: nil)
        
    }
    func userCanceledSearch(){
         dismiss(animated: true, completion: nil)
    }
}
