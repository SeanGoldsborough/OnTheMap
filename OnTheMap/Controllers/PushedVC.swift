//
//  PushedVC.swift
//  OnTheMap
//
//  Created by Sean Goldsborough on 11/6/17.
//  Copyright © 2017 Sean Goldsborough. All rights reserved.
//

import Foundation
import UIKit
class PushedVC: UIViewController {
    
    @IBAction func pushSecondVC() {
        let secondPushVC = storyboard?.instantiateViewController(withIdentifier: "SecondPushVC") as! SecondPushVC
        //myVC.locationPassed = newLocationTF.text!
        navigationController?.pushViewController(secondPushVC, animated: true)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
