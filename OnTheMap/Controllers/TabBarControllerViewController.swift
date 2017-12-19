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
        //navigationItem.rightBarButtonItems = [addPinButton]
        navigationItem.rightBarButtonItems = [addPinButton, refreshButton]
        // Do any additional setup after loading the view.

        //getOneStudent()
        
        
    }

//    func getStudents() {
//        APIClient.sharedInstance().getStudentLocationsParse( { (studentsResult, error) in
//            print("students array class is: \(self.students)")
//
//            guard studentsResult != nil else {
//                print("1There was an error with your request: \(error!)")
//                performUIUpdatesOnMain {
//                    AlertView.alertPopUp(view: self, alertMessage: "Networking Error")
//                }
//                return
//            }
//
//            if let students = studentsResult {
//
//                self.students = students
//                StudentArray.sharedInstance.listOfStudents = students
//
//                if self.isViewLoaded {
//                    performUIUpdatesOnMain {
//                        self.tableView.reloadData()
//                        ActivityIndicatorOverlay.hide()
//                        print("printing students array:\(self.students)")
//                        print("the student array class is now: \(StudentArray.sharedInstance.listOfStudents)")
//                    }
//                } else {
//                    print("put in map view reload here?")
//                }
//            } else {
//                print(error ?? "empty error")
//            }
//        })
//    }
    
//    func getOneStudent() {
//        APIClient.sharedInstance().getOneStudentLocationParse({ (result, error) in
//            //print("students array class is: \(self.students)")
//            
//            guard result != nil else {
//                print("1There was an error with your request: \(error!)")
//                performUIUpdatesOnMain {
//                    AlertView.alertPopUp(view: self, alertMessage: "Networking Error")
//                }
//                return
//            }
//        })
//    }
//
    @objc func logoutButtonTapped(sender: UIBarButtonItem) {
        
//        let logOutSession = UdacityClient()
//        
//        logOutSession.deleteSession()
//        let loginVC = self.storyboard!.instantiateViewController(withIdentifier: "LoginVC")
//        //self.performSegue(withIdentifier: "AddLocation", sender: self)
//        self.present(loginVC, animated: true, completion: nil)
        
    }
    
    @objc func addPin(sender: UIBarButtonItem) {
        
        print("addPin has been pressed")
        
        let uniqueKey = UdacityPersonalData.sharedInstance().uniqueKey //"10081758676" //UdacityPersonalData.sharedInstance().uniqueKey
        //let studentsArray = StudentArray.sharedInstance.listOfStudents//["10081758676"]
        var studentsArray = ["10081758676"]
        let moreStudents = StudentArray.sharedInstance.listOfStudents
        print("more students: \(moreStudents)")
        
        for key in moreStudents {
            print(key.uniqueKey)
            studentsArray.append(key.uniqueKey!)
        }
       
         if studentsArray.contains(uniqueKey!) {
            
            //TODO: MAKE STUDENT ARRAY A SHARED INSTANCE SO YOU CAN CALL IT HERE
        //if studentsArray.contains(where: { $0.uniqueKey == userID }) {
            // found
            print("students array contains value for current user")
            // Clicking OK on Alert Pushes AddLocationVC onto NavStack
            AlertView.addLocationAlert(view: self, alertTitle: "Update Location", alertMessage: "Would you like update a location?")
            
        } else {
            // not
            
            print("current user has not yet created a location")
            //UdacityPersonalData.sharedInstance().latitude = 55.55
            // Clicking OK on Alert Pushes AddLocationVC onto NavStack
            AlertView.addLocationAlert(view: self, alertTitle: "New Location", alertMessage: "Would you like to add a new location?")
        }
        
        
        
        //print("addPin has been pressed and we have the userID as: \(UdacityPersonalData.userFromResults(results))")
        //let addLocationNavVC = self.storyboard!.instantiateViewController(withIdentifier: "AddLocationVC") as! AddLocationVC
        //navigationController!.pushViewController(addLocationNavVC, animated: true)
    }
    
    @objc func refreshData(sender: UIBarButtonItem) {
        let listVC = self.storyboard!.instantiateViewController(withIdentifier: "ListVC")
        //listVC().getStudents()
       
        //MapVC().getStudents()
        
        
       
        
        
        print("refreshData has been pressed")
        
        if self.selectedIndex == 0 {
            
            MapVC().printFunc()
           print("refreshData has been pressed and should reload mapView")
        } else {
            ListVC().getStudents()
            
            print("refreshData has been pressed and should refresh data on tableView")
        }
        
        
        
        
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

