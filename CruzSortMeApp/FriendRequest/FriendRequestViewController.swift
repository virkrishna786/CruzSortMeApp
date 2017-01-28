//
//  FriendRequestViewController.swift
//  CruzSortMeApp
//
//  Created by Admin media on 1/28/17.
//  Copyright © 2017 Gopal Gupta. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage
import Kingfisher

class FriendRequestViewController: UIViewController , UITableViewDelegate ,UITableViewDataSource{
    
    @IBAction func menuButtonAction(_ sender: UIButton) {
        
        if boolValue == 0 {
            appDelegate.menuTableViewController.showMenu()
            self.view .addSubview(appDelegate.menuTableViewController.view)
            boolValue = 1
            
        } else {
            appDelegate.menuTableViewController.hideMenu()
            self.view .addSubview(appDelegate.menuTableViewController.view)
            boolValue = 0
        }

    }
    var boolValue = 0

    @IBOutlet weak var friendRequestTableView: UITableView!
    let cellIdentifier = "friendRequest"
    var  numberofEvents : Int!
    var eventIdString : String!
    
    
    var  homeEventArray = [FriendRequestArrayClass]()

    var userIdString : String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.friendRequestTableView.delegate = self
        self.friendRequestTableView.dataSource = self
        self.friendRequestTableView.backgroundColor = UIColor.clear
        
        let useriDstring = defaults.string(forKey: "userId")
        self.userIdString =  useriDstring!
        print("userid \(useriDstring!)")
        self.friendRequestTableView.register(UINib(nibName : "FriendRequstTableViewCell" ,bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.navigationController?.isNavigationBarHidden = false
        
        self.addChildViewController(appDelegate.menuTableViewController)
        self.friendRequestApiHit()
        
        // Do any additional setup after loading the view.
    }
    
    func friendRequestApiHit() {
        
        if currentReachabilityStatus != .notReachable {
            
            hudClass.showInView(view: self.view)
            let url = "\(baseUrl)listFriendRequest"
            
            hudClass.showInView(view: self.view)
            
            let parameter = ["user_id": "\(self.userIdString!)"]
            
            Alamofire.request( url, method : .post , parameters : parameter).responseJSON { (responseObject) -> Void in
                
                print(responseObject)
                
                if responseObject.result.isSuccess {
                    hudClass.hide()
                    let resJson = JSON(responseObject.result.value!)
                    
                    let  res_message = resJson["res_msg"].string
                    
                    if res_message == "Record Found Successfully" {
                        
                        let dataResponse = resJson["Friend"].array
                        
                        self.numberofEvents = dataResponse?.count
                        print("numberofEvents \(self.numberofEvents)")
                        
                        for eventArray in dataResponse! {
                            let eventArrayClass = FriendRequestArrayClass()
                            
                            eventArrayClass.friendRequestnameString = eventArray["username"].string
                            eventArrayClass.friendRequestIdString = eventArray["friend_id"].string
                            eventArrayClass.friendRequestImageString = eventArray["profile_image"].string

                            self.homeEventArray.append(eventArrayClass)
                        }
                        print("homeEventArray : \(self.homeEventArray)")
                        print("dataArray \(dataResponse)")
                        
                        DispatchQueue.main.async {
                            self.friendRequestTableView.reloadData()
                        }
                        print("dsfs \(resJson)")
                    }
                    
                    
                }
                if responseObject.result.isFailure {
                    hudClass.hide()
                    let error  = responseObject.result.error!  as NSError
                    parentClass.showAlertWithApiFailure()
                    print("failuredata \(error)")
                }
            }
        }else {
            parentClass.showAlert()
        }
    }
    

    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  homeEventArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! FriendRequestCell
        let eventList = homeEventArray[indexPath.row]
        print("eventLsit\(eventList)")
        
        print("event imageStrin \(eventList.friendRequestImageString!)")
        let url = URL(string : "\(eventList.friendRequestImageString!)")
        
        cell.profileImageView.kf.setImage(with: url , placeholder : UIImage(named: "aboutUs"))
        
        cell.addButton.addTarget(self, action: #selector(FriendRequestViewController.addFriendButtonAction(_sender:)), for: .touchUpInside)
        cell.declineButton.addTarget(self, action: #selector(FriendRequestViewController.declineFriendButtonAction(_sender:)), for: .touchUpInside)
        cell.nameLabel.text = eventList.friendRequestnameString!
        cell.friednRequestIdLabel.text = eventList.friendRequestIdString!
        cell.friednRequestIdLabel.isHidden = true
        return cell
    }
    
    
    func addFriendButtonAction(_sender : UIButton) {
        
        let button = _sender
        let view = button.superview!
        let cell = view.superview as! FriendRequestCell
//        let indexPath = self.friendRequestTableView!.indexPath(for: cell)
//        print("indePath: \(indexPath)")
        
        if let friendRequestIdString = cell.friednRequestIdLabel.text {
            self.addFriendApihit(string: friendRequestIdString)
        }
    }
    
    
    
    func addFriendApihit(string: String) {
        
        if currentReachabilityStatus != .notReachable {
            
            hudClass.showInView(view: self.view)
            let url = "\(baseUrl)acceptRequest"
            
            hudClass.showInView(view: self.view)
            
            let parameter = ["user_id": "\(self.userIdString!)",
                              "friend_id" : "\(string)"
            ]
            
            print("poram : \(parameter)")
            
            Alamofire.request( url, method : .post , parameters : parameter).responseJSON { (responseObject) -> Void in
                
                print(responseObject)
                
                if responseObject.result.isSuccess {
                    self.friendRequestTableView.isHidden = false
                    hudClass.hide()
                    let resJson = JSON(responseObject.result.value!)
                    
                    let  res_message = resJson["res_msg"].string
                    
                    if res_message == "Accept Successfully" {
                        
                        print("Accepty succesfully")
                        
                        DispatchQueue.main.async {
                            self.friendRequestApiHit()
                        }
                        print("dsfs \(resJson)")
                    }
                  
                }
                if responseObject.result.isFailure {
                    hudClass.hide()
                    let error  = responseObject.result.error!  as NSError
                    parentClass.showAlertWithApiFailure()
                    print("failuredata \(error)")
                    
                }
            }
        }else {
            parentClass.showAlert()
        }
    }
    
    
    func declineFriendButtonAction(_sender : UIButton) {
        
        let button = _sender
        let view = button.superview!

        let cell = view.superview as! FriendRequestCell
        
        let indexPath = self.friendRequestTableView!.indexPath(for: cell)
        
        print("indePath: \(indexPath)")
        
        if let friendRequestIdString = cell.friednRequestIdLabel.text {
            self.declineApihit(string: friendRequestIdString)
        }
        
        
    }
    
    
    func declineApihit(string: String) {
        
        if currentReachabilityStatus != .notReachable {
            
            hudClass.showInView(view: self.view)
            let url = "\(baseUrl)friendRequestDeclined"
            
            hudClass.showInView(view: self.view)
            
            let parameter = ["user_id": "\(self.userIdString!)",
                "friend_id" : "\(string)"
            ]
            
            Alamofire.request( url, method : .post , parameters : parameter).responseJSON { (responseObject) -> Void in
                
                print(responseObject)
                
                if responseObject.result.isSuccess {
                    self.friendRequestTableView.isHidden = false
                    hudClass.hide()
                    let resJson = JSON(responseObject.result.value!)
                    
                    let  res_message = resJson["res_msg"].string
                    
                    if res_message == "Declined Successfully" {
                        DispatchQueue.main.async {
                            self.friendRequestApiHit()
                        }
                        print("dsfs \(resJson)")
                    }
                    
            }
                if responseObject.result.isFailure {
                    hudClass.hide()
                    let error  = responseObject.result.error!  as NSError
                    parentClass.showAlertWithApiFailure()
                    print("failuredata \(error)")
                    
                }
            }
        }else {
            parentClass.showAlert()
        }
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        let eventList = homeEventArray[indexPath.row]
//        self.eventIdString = eventList.eventID!
//        self.performSegue(withIdentifier: "eventDetail", sender: self)
//        print("eventIDString \(self.eventIdString!)")
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "eventDetail" {
          //  let eventDetailView = segue.destination as! EventDetailViewController
            // eventDetailView.delegate = self
           // eventDetailView.eventIdString = self.!
           // print("homepage eventIDString \(eventDetailView.eventIdString)")
            
        }

        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
