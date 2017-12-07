//
//  TabBarControllerViewController.swift
//  OnTheMap
//
//  Created by Sean Goldsborough on 11/7/17.
//  Copyright © 2017 Sean Goldsborough. All rights reserved.
//

import UIKit

class TabBarControllerViewController: UITabBarController {
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logOutButton = UIBarButtonItem(title: "LOGOUT", style: .plain, target: self, action: #selector(logoutButtonTapped(sender: )))
        let refreshButton = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_refresh"), landscapeImagePhone: #imageLiteral(resourceName: "icon_refresh"), style: .plain, target: self, action: #selector(refreshData(sender: )))
        let addPinButton = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_addpin"), landscapeImagePhone: #imageLiteral(resourceName: "icon_addpin"), style: .plain, target: self, action: #selector(addPin(sender: )))
       
        navigationItem.leftBarButtonItems = [logOutButton]
        navigationItem.rightBarButtonItems = [addPinButton, refreshButton]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func logoutButtonTapped(sender: UIBarButtonItem) {
        
        let logOutSession = UdacityClient()
        
        logOutSession.deleteSession()
        let loginVC = self.storyboard!.instantiateViewController(withIdentifier: "LoginVC")
        //self.performSegue(withIdentifier: "AddLocation", sender: self)
        self.present(loginVC, animated: true, completion: nil)
        
    }
    
    @objc func addPin(sender: UIBarButtonItem) {
        print("addPin has been pressed")
        
        //let UdacityPersonalData.sharedInstance().uniqueKey = "8266875466"
        let uniqueKey = "10081758676"
        let userID = "10081758676" //UdacityPersonalData.sharedInstance().uniqueKey
        let studentsArray = [StudentLocations]()
        if userID == uniqueKey {
            
            //TODO: MAKE STUDENT ARRAY A SHARED INSTANCE SO YOU CAN CALL IT HERE
        //if studentsArray.contains(where: { $0.uniqueKey == userID }) {
            // found
            print("students array contains value for current user")
            AlertView.addLocationAlert(view: self, alertTitle: "Update Location", alertMessage: "Would you like update a location?")
            
        } else {
            // not
            print("current user has not yet created a location")
            UdacityPersonalData.sharedInstance().latitude = 55.55
            AlertView.addLocationAlert(view: self, alertTitle: "New Location", alertMessage: "Would you like to add a new location?")
        }
        
        
        
        //print("addPin has been pressed and we have the userID as: \(UdacityPersonalData.userFromResults(results))")
        //let addLocationNavVC = self.storyboard!.instantiateViewController(withIdentifier: "AddLocationVC") as! AddLocationVC
        //navigationController!.pushViewController(addLocationNavVC, animated: true)
    }
    
    @objc func refreshData(sender: UIBarButtonItem) {
        //self.activityIndicatorView.startAnimating()
        //refreshData(self)
        let listView = self.storyboard!.instantiateViewController(withIdentifier: "ListVC") as! ListVC
        
        let mapView = self.storyboard!.instantiateViewController(withIdentifier: "MapVC") as! MapVC
        ActivityIndicatorOverlay.show("Loading...")
        
        
        // simulate time consuming work
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.hideIndicator), userInfo: nil, repeats: false)
//        
//        listView.updateView()
//        
//        listView.printStudentNames()
        
        // TODO: ADD TAG #s to BUTTONS - Do tab bar buttons programmatically with tags...if tag = 0 (mapview is shown) then run mapVC funcs, else run listVC funcs
        
        if tabBarItem.tag == 0 {
            listView.updateView()
           print("tableView has been reloaded")
            
        } else {
            print("ERROR!!!: TableView has NOT been reloaded")
            
            //listView.printStudentNames()
        }
        
//        mapView.mapView.reloadInputViews()
    }
    @objc func hideIndicator() {
        ActivityIndicatorOverlay.hide()
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

