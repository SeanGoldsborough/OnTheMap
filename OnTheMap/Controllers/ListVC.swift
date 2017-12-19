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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        ActivityIndicatorOverlay.show(self.view, "Locating...")
        //ActivityIndicatorOverlay.show(self.tableView, loadingText: "Locating...")
        //Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(MapVC.hideIndicator), userInfo: nil, repeats: false)
        
        self.navigationController?.navigationBar.isHidden = false
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LOGOUT", style: .plain, target: self, action: #selector(logoutButtonTapped(sender: )))
//        let refreshButton = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_refresh"), landscapeImagePhone: #imageLiteral(resourceName: "icon_refresh"), style: .plain, target: self, action: #selector(refreshData(sender: )))
//        let addPinButton = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_addpin"), landscapeImagePhone: #imageLiteral(resourceName: "icon_addpin"), style: .plain, target: self, action: #selector(addPin(sender: )))
//        navigationItem.rightBarButtonItems = [addPinButton, refreshButton]
        
        
        
        tabBarController?.tabBar.isHidden = false
        
        tableView.dataSource = self
        tableView.delegate = self
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        // Configure Refresh Control
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
                AlertView.alertPopUp(view: self, alertMessage: "Networking Error")
                }
                return
            }

                if let students = studentsResult {
    
                    self.students = students
                    StudentArray.sharedInstance.listOfStudents = students
                    
                    if self.isViewLoaded {
                        performUIUpdatesOnMain {
                            self.tableView.reloadData()
                            ActivityIndicatorOverlay.hide()
                            print("printing students array:\(self.students)")
                            print("the student array class is now: \(StudentArray.sharedInstance.listOfStudents)")
                        }
                    } else {
                        print("put in map view reload here?")
                    }
                } else {
                    print(error ?? "empty error")
            }
        }

        APIClient.sharedInstance().getPublicUserDataUdacity { (result, error) in
            
            guard result != nil else {
                print("There was an error with your request - getPublicUserDataUdacity: \(error)")
                performUIUpdatesOnMain {
                    AlertView.alertPopUp(view: self, alertMessage: "Networking Error")
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
                    AlertView.alertPopUp(view: self, alertMessage: "Networking Error")
                }
                return
            }
        })
    }
    

//    @objc func logoutButtonTapped(sender: UIBarButtonItem) {
//        print("logout tableview pressed")
//        let logOutSession = UdacityClient()
//
//        logOutSession.deleteSession()
//        let loginVC = self.storyboard!.instantiateViewController(withIdentifier: "LoginVC")
//        //self.performSegue(withIdentifier: "AddLocation", sender: self)
//        self.present(loginVC, animated: true, completion: nil)
//
//    }
//
//    @objc func addPin(sender: UIBarButtonItem) {
//        let addLocationNavVC = self.storyboard!.instantiateViewController(withIdentifier: "AddLocationVC") as! AddLocationVC
//        navigationController!.pushViewController(addLocationNavVC, animated: true)
//    }
//
//    @objc func refreshData(sender: UIBarButtonItem) {
//        //self.activityIndicatorView.startAnimating()
//        //refreshData(self)
//        //ActivityIndicatorOverlay.show(self.view, "Loading...")
//
//        // simulate time consuming work
//        //Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.hideIndicator), userInfo: nil, repeats: false)
//        performUIUpdatesOnMain {
//            self.tableView.reloadData()
//            print("updateview called: tableView has been reloaded")
//        }
//    }
    
    @objc func hideIndicator() {
        ActivityIndicatorOverlay.hide()
    }
    
//    static func reloadTable() {
//        performUIUpdatesOnMain {
//            self.tableView.reloadData()
//            print("updateview called: tableView has been reloaded")
//        }
//    }
    
    func updateView() {
        print("updateview called")
        
//        performUIUpdatesOnMain {
//            self.tableView.reloadData()
//            print("updateview called: tableView has been reloaded")
//        }
        
        if students.count > 0  {
            getStudents()
            
            let listView = ListVC()
            if listView.isViewLoaded {
                performUIUpdatesOnMain {
                    self.tableView.reloadData()
                }
            } else {
                print("put in map view reload here?")
            }
            
        } else {
            performUIUpdatesOnMain {
                AlertView.alertPopUp(view: self, alertMessage: "Networking Error")
            }
        }
        
        print(students.count)
    }
    
    @objc private func refreshData(_ sender: Any) {
        fetchData()
    }
    
    func fetchData() {
        
        getStudents()
        print("the students array is: \(students)")
        
        performUIUpdatesOnMain {
            self.tableView.reloadData()
            self.updateView()
            self.activityIndicatorView.stopAnimating()
            refreshControl.endRefreshing()
        }
    }
    
    private func setupActivityIndicatorView() {
        activityIndicatorView.startAnimating()
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
        let studentWeb = studentFirstName.mediaURL//String(studentWebsite[indexPath.row])
        
        let url = URL(string:studentWeb!)
        print(url)
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        
    }
    
}
