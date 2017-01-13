//
//  FriendListViewController.swift
//  CruzSortMeApp
//
//  Created by Admin media on 1/13/17.
//  Copyright © 2017 Gopal Gupta. All rights reserved.
//

import UIKit
import Alamofire
import  AlamofireImage
import SwiftyJSON

class FriendListViewController: UIViewController ,UITableViewDataSource ,UITableViewDelegate  ,UISearchBarDelegate ,UISearchDisplayDelegate {
    
    var userIdString : String!
    var numberOfEvents : Int!
    @IBOutlet weak var friendSearchBar: UISearchBar!
    @IBOutlet weak var friendListTableView: UITableView!
    
    var marrFilteredFriendList = [FriendListClass]()

    
    let cellIdentifier = "friendListCellTypee"
    var friendsListArray = [FriendListClass]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.friendListTableView.delegate = self
        self.friendListTableView.dataSource = self
        let userid = defaults.string(forKey: "userId")
        self.userIdString = userid!
        print("self.userid \(self.userIdString)")
        
         self.friendListTableView.register(UINib(nibName : "FriendListCell" ,bundle: nil), forCellReuseIdentifier: cellIdentifier)
        DispatchQueue.global(qos: .background).async {
            self.friendListApi()
        }

        // Do any additional setup after loading the view.
    }
    
    
    func friendListApi() {
        
        let url = "http://182.73.133.220/CruzSortMe/Apis/friendList"
        
        let paramter = ["user_id": self.userIdString!]
        
        Alamofire.request( url, method : .post  ,parameters : paramter).responseJSON { (responseObject) -> Void in
            
            print(responseObject)
            
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                
                    let dataResponse = resJson["Friend"].array
                    
                    self.numberOfEvents = dataResponse?.count
                    print("numberofEvents \(self.numberOfEvents)")
                    
                    for eventArray in dataResponse! {
                        let eventArrayClass = FriendListClass()
                        
                        eventArrayClass.friendNameString = eventArray["username"].string
                        eventArrayClass.friendIdString = eventArray["friend_id"].string
                        eventArrayClass.friendProfileImage = eventArray["profile_image"].string
                        self.friendsListArray.append(eventArrayClass)
                    }
                    print("homeEventArray : \(self.friendsListArray)")
                    print("dataArray \(dataResponse)")
                    DispatchQueue.main.async {
                        self.friendListTableView.reloadData()
                    }
                
                print("dsfs \(resJson)")
            }
            if responseObject.result.isFailure {
                let error  = responseObject.result.error!  as NSError
                print("\(error)")
                
            }
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return self.marrFilteredFriendList.count
        } else {
            return self.friendsListArray.count
        }    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)! as! FriendListCellType
        var friendName : String!

        let eventList = friendsListArray[indexPath.row]
        print("eventLsit\(eventList)")
        
//        if tableView == self.searchDisplayController!.searchResultsTableView {
//            friendName = marrFilteredFriendList[indexPath.row]
//        } else {
//            friendName = friendsListArray[indexPath.row]
//        }
        
        cell.friendNameLabel.text = friendName!
        cell.friendNameLabel.text = eventList.friendNameString!
        
        print("event imageString = \(eventList.friendProfileImage!)")
        let URL = NSURL(string: "\(eventList.friendProfileImage!)")
        print("urlsfgds \(URL)")
        let mutableUrlRequest = NSMutableURLRequest(url: URL! as URL)
        mutableUrlRequest.httpMethod = "get"
        
        mutableUrlRequest.setValue("image/jpeg", forHTTPHeaderField: "Accept")
        
        
        let headers = [
            "Accept"  :  "image/jpeg"
        ]
        print(" headers \(headers)")
        print("mutable Request : \(mutableUrlRequest)")
        //  request.addAcceptableImageContentTypes(["image/jpeg"])
        
        Alamofire.request("\(URL!)").responseImage { response in
            debugPrint(response)
            
            print("adsfdfs \(response.request!)")
            print("dskjfd \(response.response!)")
            print(" response.result \(response.result)")
            
            if let image = response.result.value {
                DispatchQueue.global().async(execute: {
                    
                    if let cellToUpdate = tableView.cellForRow(at: indexPath) {
                        
                        print("\(cellToUpdate)")
                        cell.friendProfileImageView.image = image
                    }
                    
                })
                
            }
        }

        
        
        
        
      //  self.IntrestIdString = eventList.interestId!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
          //  self.selectedInterestArray.append((cell.textLabel?.text)!)
//            print(" selected cell \(cell.textLabel?.text)")
//            print("selecgted \(self.selectedInterestArray)")
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
