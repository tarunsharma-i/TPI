//
//  ViewController.swift
//  TPI
//
//  Created by Tarun Sharma on 28/06/22.
//

import UIKit
import Alamofire
import MBProgressHUD
import SwiftyJSON

class Downloader {
    class func downloadImageFromURL(urlString : String) -> UIImage {
        let url = URL(string: urlString)!
        let data = NSData(contentsOf: url)
        return UIImage(data: data! as Data)!
    }
}


class ViewController: UIViewController {
    
    var url = "https://reqres.in/api/users?page=2"
    
    var userList = [User]()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getResponseFromURL(url: url)
        tableView.dataSource = self
    }
    
    func getResponseFromURL(url : String) {
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).response { response in
         
        //AF.request(url).validate().response { (response) in
        
            guard response.error == nil else {return}
            let code = (response.response)
            print(code!.statusCode)
            
            let user = try? JSONDecoder().decode(UserResponse.self, from: response.data!)
            
            self.userList = user!.data
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}


extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath) as! CustomTableViewCell
        
        let indexedArray = userList[indexPath.row]
        let firstName = indexedArray.first_name
        let lastName = indexedArray.last_name
        
        cell.nameLabel.text = firstName + " " + lastName
        cell.emailLabel.text = indexedArray.email
        cell.profileImageView.image = Downloader.downloadImageFromURL(urlString: indexedArray.avatar)
        
        return cell
    }
    
    
    
    
    
}








struct User : Decodable {
    var id : Int
    var email : String
    var first_name : String
    var last_name : String
    var avatar : String
}


struct UserResponse : Decodable {
    var page : Int
    var total : Int
    var data : [User]
}

