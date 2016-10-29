//
//  SettingsViewController.swift
//  Weather
//
//  Created by Vladimir on 28.10.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import UIKit

protocol SettingDelegate: class{
    func userFinishedChangingSettings()
}

class SettingsViewController: UIViewController {
    
    weak var backDelegate: SettingDelegate?

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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
