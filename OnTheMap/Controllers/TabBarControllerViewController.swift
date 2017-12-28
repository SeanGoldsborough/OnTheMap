//
//  TabBarControllerViewController.swift
//  OnTheMap
//
//  Created by Sean Goldsborough on 12/21/17.
//  Copyright © 2017 Sean Goldsborough. All rights reserved.
//

import Foundation
import UIKit

class TabBarControllerViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        print("tab view did disappear")
    }
 
}
