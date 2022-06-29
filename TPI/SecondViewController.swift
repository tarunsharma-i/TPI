//
//  SecondViewController.swift
//  TPI
//
//  Created by Tarun Sharma on 29/06/22.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD

class SecondViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var url = "https://reqres.in/api/users?page=2"
    var userList = [JSON]()         // SwiftyJSON
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        getResponseFromURL(url: url)
    }
    
    
    func getResponseFromURL(url : String) {
        AF.request(url).validate().response { (response) in
            
            let responseData    = try? JSON(data: response.data!)   // SwiftyJSON
            let listOfUsers     = (responseData?["data"])?.array    // SwiftyJSON
            self.userList = listOfUsers!
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}


extension SecondViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath)
        let indexArray  = userList[indexPath.row]
        let firstName   = (indexArray["first_name"].string)!
        let lastName    =  (indexArray["last_name"].string)!
        
        cell.textLabel?.text        = firstName + " " + lastName
        cell.detailTextLabel?.text  = indexArray["email"].string     
        return cell
    }
}
