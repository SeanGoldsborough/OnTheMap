//
//  SecondPushVC.swift
//  OnTheMap
//
//  Created by Sean Goldsborough on 11/6/17.
//  Copyright © 2017 Sean Goldsborough. All rights reserved.
//

import Foundation
import UIKit
class SecondPushVC: UIViewController {
    
    @IBAction func pushSecondVC() {
        let testVC = storyboard?.instantiateViewController(withIdentifier: "TestVC")
        //myVC.locationPassed = newLocationTF.text!
        navigationController?.popToViewController(testVC!, animated: true)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
