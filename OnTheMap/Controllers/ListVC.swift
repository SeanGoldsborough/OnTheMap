//
//  ListVC.swift
//  OnTheMap
//
//  Created by Sean Goldsborough on 10/17/17.
//  Copyright © 2017 Sean Goldsborough. All rights reserved.
//

import Foundation
import UIKit

var myArray = ["name1", "name2", "name3"]

class ListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addPin(_ sender: Any) {
        
        let addLocationNavVC = self.storyboard!.instantiateViewController(withIdentifier: "AddLocationVCNav")
        self.present(addLocationNavVC, animated: true, completion: nil)
        //navigationController!.pushViewController(addLocationNavVC, animated: true)
        //try diff seques or pushing the add location vc onto the nav stack and having the nav bar change when it happens.
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = myArray[indexPath.row]
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let whereAreYouVC = self.storyboard!.instantiateViewController(withIdentifier: "WhereAreYouVC")
        navigationController!.pushViewController(whereAreYouVC, animated: true)
        
        
    }
    
    
    
    
}
