//
//  ListVC.swift
//  OnTheMap
//
//  Created by Sean Goldsborough on 10/17/17.
//  Copyright © 2017 Sean Goldsborough. All rights reserved.
//
import Foundation
import UIKit

//var studentName = ["Jack", "Konrad", "Olivia"]
//var studentWebsite = ["https://www.google.com", "https://www.yahoo.com", "https://www.udacity.com"]

private let refreshControl = UIRefreshControl()

class ListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    
    let reuseIdentifier = "Cell"
    
    var students: [StudentLocations] = [StudentLocations]()
    
    @IBOutlet weak var tableView: UITableView!
    
   
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
   
//    @IBAction func refreshButton(_ sender: UIBarButtonItem) {
//
//        //self.activityIndicatorView.startAnimating()
//        //refreshData(self)
//        ActivityIndicatorOverlay.show("Loading...")
//
//        // simulate time consuming work
//        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(ListVC.hideIndicator), userInfo: nil, repeats: false)
//
//        self.tableView.reloadData()
//    }
//
//    @objc func hideIndicator() {
//        ActivityIndicatorOverlay.hide()
//    }
//    
//    
//   
//    @IBAction func addPin(_ sender: Any) {
//        print("POOOP@!!!")
//        let addLocationNavVC = self.storyboard!.instantiateViewController(withIdentifier: "AddLocationVC") as! AddLocationVC
//        navigationController!.pushViewController(addLocationNavVC, animated: true)
//        //try diff seques or pushing the add location vc onto the nav stack and having the nav bar change when it happens.
//
//    }
    
//    @IBAction func logOut(_ sender: Any) {
//
//        let logOutSession = UdacityClient()
//
//        logOutSession.deleteSession()
//        let loginVC = self.storyboard!.instantiateViewController(withIdentifier: "LoginVC")
//        //self.performSegue(withIdentifier: "AddLocation", sender: self)
//        self.present(loginVC, animated: true, completion: nil)
//
//    }
    
    
    
//    func printStudentNames() {
//        print([studentName])
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        ActivityIndicatorOverlay.show("Loading...")
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(MapVC.hideIndicator), userInfo: nil, repeats: false)
        
        self.navigationController?.navigationBar.isHidden = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LOGOUT", style: .plain, target: self, action: #selector(logoutButtonTapped(sender: )))
        let refreshButton = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_refresh"), landscapeImagePhone: #imageLiteral(resourceName: "icon_refresh"), style: .plain, target: self, action: #selector(refreshData(sender: )))
        let addPinButton = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_addpin"), landscapeImagePhone: #imageLiteral(resourceName: "icon_addpin"), style: .plain, target: self, action: #selector(addPin(sender: )))
        navigationItem.rightBarButtonItems = [addPinButton, refreshButton]
        
        fetchData()
        
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
        refreshControl.tintColor = UIColor(red:0.75, green:0.72, blue:1.0, alpha:1.0)
        refreshControl.attributedTitle = NSAttributedString(string: "Loading ...", attributes: nil)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("xxx students array:\(self.students)")
//        getStudents()
        
    }
    
    func getStudents() {
        APIClient.sharedInstance().getStudentLocationsParse { (students, error) in
 
                if let students = students {
    //                let studentsFiltered = students.filter { $0 != nil }
                        self.students = students //as in the constant from if/let statement which = movies returned by comp hand
    //self.students = studentsFiltered //as in the constant from if/let statement which = movies returned by comp hand
    
                    performUIUpdatesOnMain {
                        self.tableView.reloadData()
                        print("printing students array:\(self.students)")
                    }

                } else {
                    print(error ?? "empty error")
            }
    }
    
        APIClient.sharedInstance().getPublicUserDataUdacity { (result, error) in
            if let results = result {
                print("printing results from getPublicDataUdacity:\(results)")
            } else {
                print(error ?? "empty error")
            }
    
        }
    
    //        APIClient.sharedInstance().getOneStudentLocationParse { (students, error) in
    //
    //
    //
    //            if let students = students {
    //                //                let studentsFiltered = students.filter { $0 != nil }
    //                self.students = students //as in the constant from if/let statement which = movies returned by comp hand
    //                //self.students = studentsFiltered //as in the constant from if/let statement which = movies returned by comp hand
    //
    //                performUIUpdatesOnMain {
    //                    //self.tableView.reloadData()
    //                    print("printing One student array:\(self.students)")
    //                }
    //
    //
    //            } else {
    //                print(error ?? "empty error")
    //            }
    //        }
    }
    @objc func logoutButtonTapped(sender: UIBarButtonItem) {
        print("logout tableview pressed")
        let logOutSession = UdacityClient()

        logOutSession.deleteSession()
        let loginVC = self.storyboard!.instantiateViewController(withIdentifier: "LoginVC")
        //self.performSegue(withIdentifier: "AddLocation", sender: self)
        self.present(loginVC, animated: true, completion: nil)

    }

    @objc func addPin(sender: UIBarButtonItem) {
        let addLocationNavVC = self.storyboard!.instantiateViewController(withIdentifier: "AddLocationVC") as! AddLocationVC
        navigationController!.pushViewController(addLocationNavVC, animated: true)
    }

    @objc func refreshData(sender: UIBarButtonItem) {
        //self.activityIndicatorView.startAnimating()
        //refreshData(self)
        ActivityIndicatorOverlay.show("Loading...")

        // simulate time consuming work
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.hideIndicator), userInfo: nil, repeats: false)
        print("tableView.reloadData pressed")
        self.tableView.reloadData()
    }
    @objc func hideIndicator() {
        ActivityIndicatorOverlay.hide()
    }
    
    func updateView() {
        
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        contactsArray = appDelegate.arrayOfContacts
//        contactsPhone = appDelegate.arrayOfNum
        
        let hasContacts = students.count > 0 //&& studentWebsite.count > 0
        //        tableView.isHidden = !hasContacts
        
        if hasContacts {
            getStudents()
            self.tableView.reloadData()
            print("updateview called: tableView has been reloaded")
        } else {
            
            // Setup Alert Message
            let alert = UIAlertController(title: "Error:", message: "There are no contacts to show", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        print(students.count)
        //print(arrayOfContacts.count)
        
        
    }
    
    @objc private func refreshData(_ sender: Any) {
        fetchData()
    }
    
    private func fetchData() {
        getStudents()
        print("the students array is: \(students)")
        DispatchQueue.main.async{
            
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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return students.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        
        // TODO: Filter out all no name/no value nils in array...Maybe.
        //self.students.filter { $0 != nil }
        for student in students {
            let studentFirstName = students[indexPath.row]
            
            let firstName = studentFirstName.firstName!
            let lastName = studentFirstName.lastName!
            let fullName = firstName + " " + lastName as! String
            cell.textLabel!.text = fullName
            //cell.textLabel!.text = studentFirstName.firstName
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
        
        //        let whereAreYouVC = self.storyboard!.instantiateViewController(withIdentifier: "WhereAreYouVC")
        //        navigationController!.pushViewController(whereAreYouVC, animated: true)
        
        
    }
    
    
    
    
}
