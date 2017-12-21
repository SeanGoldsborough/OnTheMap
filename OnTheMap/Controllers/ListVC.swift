//
//  ListVC.swift
//  OnTheMap
//
//  Created by Sean Goldsborough on 10/17/17.
//  Copyright © 2017 Sean Goldsborough. All rights reserved.
//
import Foundation
import UIKit

private let refreshControl = UIRefreshControl()

class ListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    
    let reuseIdentifier = "Cell"
    
    var students: [StudentLocations] = StudentArray.sharedInstance.listOfStudents
    
    @IBOutlet weak var tableView: UITableView!
    
   
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    @IBAction func logoutButton(_ sender: Any) {
        
        ActivityIndicatorOverlay.show(self.view, loadingText: "Logging out...")
        APIClient.sharedInstance().deleteSessionUdacity(sessionID: APIClient.sharedInstance().sessionID) { (success, error) in
            
            if success == true {
                
                let loginVC = self.storyboard!.instantiateViewController(withIdentifier: "LoginVC")
                
                performUIUpdatesOnMain {
                    ActivityIndicatorOverlay.hide()
                    self.present(loginVC, animated: true, completion: nil)
                }
                
                print("logged out")
                
            } else {
                
                performUIUpdatesOnMain {
                    AlertView.alertPopUp(view: self, alertMessage: "Error Logging Out")
                    ActivityIndicatorOverlay.hide()
                }
                
                print("error logging out")
            }
        }
    }
    
    @IBAction func addPinButton(_ sender: Any) {
        print("addPin has been pressed")
        
        let uniqueKey = UdacityPersonalData.sharedInstance().uniqueKey
        var studentsArray = ["10081758676"]
        let moreStudents = StudentArray.sharedInstance.listOfStudents
        print("more students: \(moreStudents)")
        
        for key in moreStudents {
            print(key.uniqueKey)
            studentsArray.append(key.uniqueKey!)
        }
        
        if studentsArray.contains(uniqueKey!) {
            print("students array contains value for current user")
            AlertView.addLocationAlert(view: self, alertTitle: "Update Location", alertMessage: "Would you like update a location?")
            
        } else {
            print("current user has not yet created a location")
            AlertView.addLocationAlert(view: self, alertTitle: "New Location", alertMessage: "Would you like to add a new location?")
        }
    }
    
    @IBAction func refreshButton(_ sender: Any) {
        
        ActivityIndicatorOverlay.show(self.view, loadingText: "Locating...")
        getStudents()
        print("ListVC refreshButton has been pressed")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ActivityIndicatorOverlay.show(self.view, "Locating...")
    
        self.navigationController?.navigationBar.isHidden = false

        tabBarController?.tabBar.isHidden = false
        
        tableView.dataSource = self
        tableView.delegate = self
        

        
        // Pull to Refresh Control Config
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
        refreshControl.attributedTitle = NSAttributedString(string: "Loading ...", attributes: nil)
        
        fetchData()
        
        getOneStudent()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("xxx students array:\(self.students)")
    }
    
    func getStudents() {
        APIClient.sharedInstance().getStudentLocationsParse { (studentsResult, error) in
            print("students array class is: \(self.students)")
            
            performUIUpdatesOnMain {
                ActivityIndicatorOverlay.show(self.view, loadingText: "Loading...")
            }
            
            guard studentsResult != nil else {
                print("1There was an error with your request -getStudentsListVC: \(error)")
                performUIUpdatesOnMain {
                    ActivityIndicatorOverlay.hide()
                    AlertView.alertPopUp(view: self, alertMessage: "Networking Error0")
                }
                return
            }
                if let students = studentsResult {
    
                    self.students = students
                    StudentArray.sharedInstance.listOfStudents = students
                    
                    performUIUpdatesOnMain {
                        self.tableView.reloadData()
                        ActivityIndicatorOverlay.hide()
                        print("printing students array:\(self.students)")
                        print("the student array class is now: \(StudentArray.sharedInstance.listOfStudents)")
                    }
                    
                } else {
                    print(error ?? "empty error")
            }
        }

        APIClient.sharedInstance().getPublicUserDataUdacity { (result, error) in
            
            guard result != nil else {
                print("There was an error with your request - getPublicUserDataUdacity: \(error)")
                performUIUpdatesOnMain {
                    AlertView.alertPopUp(view: self, alertMessage: "Networking Error1")
                }
                return
            }
        }
    }
    
    func getOneStudent() {
        APIClient.sharedInstance().getOneStudentLocationParse({ (result, error) in
            
            guard result != nil else {
                print("There was an error with your request - getOneStudent: \(error)")
                performUIUpdatesOnMain {
                    AlertView.alertPopUp(view: self, alertMessage: "Networking Error2")
                }
                return
            }
        })
    }
    

     // Pull to Refresh Control functions
    
    @objc func refreshData(_ sender: Any) {
        refreshControl.beginRefreshing()
        fetchData()
    }
    
    func fetchData() {
        
        getStudents()
        print("the students array is: \(students)")
        
        performUIUpdatesOnMain {
            self.updateView()
            self.activityIndicatorView.stopAnimating()
            refreshControl.endRefreshing()
        }
    }
    
    func updateView() {
        print("updateview called")
        performUIUpdatesOnMain {
            self.tableView.reloadData()
        }
    }
    
    @objc func setupActivityIndicatorView() {
        ActivityIndicatorOverlay.show(self.view, loadingText: "")
        activityIndicatorView.startAnimating()
    }
    
    @objc func hideIndicator() {
        ActivityIndicatorOverlay.hide()
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return students.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        for student in students {
            let studentFirstName = students[indexPath.row]
            
            let firstName = studentFirstName.firstName!
            let lastName = studentFirstName.lastName!
            let fullName = firstName + " " + lastName as! String
            cell.textLabel!.text = fullName
            cell.detailTextLabel!.text = studentFirstName.mediaURL
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let studentFirstName = students[indexPath.row]
        let studentWeb = studentFirstName.mediaURL
        
        let url = URL(string:studentWeb!)
        print(url)
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        
    }
    
}
