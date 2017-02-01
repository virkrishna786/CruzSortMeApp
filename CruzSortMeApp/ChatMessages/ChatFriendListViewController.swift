//
//  ChatFriendListViewController.swift
//  CruzSortMeApp
//
//  Created by Admin media on 1/31/17.
//  Copyright © 2017 Gopal Gupta. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage
import Kingfisher


class ChatFriendListViewController: UIViewController , UITableViewDelegate ,UITableViewDataSource {

    var boolValue = 0
    
    let cellIdentifier = "chatFriendList"
    var  numberofEvents : Int!
    var friendIdString : String!
    
    var userIdString : String!
    var  chatfriendArray = [ChatFriendListArrayClass]()
    @IBOutlet weak var chatFriendListTableView: UITableView!{
        didSet{
            self.chatFriendListTableView.layer.cornerRadius = 5
        }
    }
    @IBAction func meneButtonAction(_ sender: UIButton) {
        
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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.chatFriendListTableView.delegate = self
        self.chatFriendListTableView.dataSource = self
        self.chatFriendListTableView.backgroundColor = UIColor.clear
        
        
        let useriDstring = defaults.string(forKey: "userId")
        self.userIdString =  useriDstring!
        print("userid \(useriDstring!)")
        
        self.chatFriendListTableView.register(UINib(nibName : "ChatFriendListCell" ,bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.navigationController?.isNavigationBarHidden = false
        
        self.eventApiHit()
        self.addChildViewController(appDelegate.menuTableViewController)
        self.chatFriendListTableView.tableFooterView = UIView()


        // Do any additional setup after loading the view.
    }
    
    func eventApiHit() {
        
        if currentReachabilityStatus != .notReachable {
            
            hudClass.showInView(view: self.view)
            let url = "\(baseUrl)chatLists"
            
            hudClass.showInView(view: self.view)
            
            let parameter = ["user_id": "\(self.userIdString!)"]
            
            Alamofire.request( url, method : .post , parameters : parameter).responseJSON { (responseObject) -> Void in
                
                print(responseObject)
                
                if responseObject.result.isSuccess {
                    self.chatFriendListTableView.isHidden = false
                    hudClass.hide()
                    let resJson = JSON(responseObject.result.value!)
                    
                    let  res_message = resJson["res_msg"].string
                    
                    if res_message == "Record  Found Successfully" {
                        
                        let dataResponse = resJson["Friend"].array
                        
                        self.numberofEvents = dataResponse?.count
                        print("numberofEvents \(self.numberofEvents)")
                        
                        for eventArray in dataResponse! {
                            let eventArrayClass = ChatFriendListArrayClass()
                            eventArrayClass.chatFriendIDString = eventArray["friend_id"].string
                            eventArrayClass.chatFriendName = eventArray["username"].string
                            eventArrayClass.chatFriendProfileimageString = eventArray["profile_image"].string
                            eventArrayClass.isFriendString = eventArray["isfriend"].string
                            
                            self.chatfriendArray.append(eventArrayClass)
                        }
                        print("homeEventArray : \(self.chatfriendArray)")
                        print("dataArray \(dataResponse)")
                    }else {
                        self.chatFriendListTableView.isHidden = true
                        let label = UILabel()
                        self.view.addSubview(parentClass.setBlankView(label: label))
                    }
                    
                    DispatchQueue.main.async {
                        self.chatFriendListTableView.reloadData()
                    }
                    print("dsfs \(resJson)")
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
        return  chatfriendArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)! as! ChatFriendListCellType
        // cell.eventImageView.image = UIImage(named: "dummy")
        let eventList = chatfriendArray[indexPath.row]
        print("eventLsit\(eventList)")
        
        print("event imageString = \(eventList.chatFriendProfileimageString!)")
        let url = URL(string : "\(eventList.chatFriendProfileimageString!)")
        
        cell.profileImageView.kf.setImage(with: url , placeholder : UIImage(named: "dummy"))
                cell.friendNameLabel.text = eventList.chatFriendName!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let eventList = chatfriendArray[indexPath.row]
        self.friendIdString = eventList.chatFriendIDString!
        self.performSegue(withIdentifier: "chatView", sender: self)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "chatView" {
            let eventDetailView = segue.destination as! ChatViewController
            // eventDetailView.delegate = self
            eventDetailView.friendIdString = self.friendIdString!
            print("homepage eventIDString \(eventDetailView.friendIdString)")
        }

        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
