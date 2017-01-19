//
//  FriendGroupViewController.swift
//  CruzSortMeApp
//
//  Created by Admin media on 1/17/17.
//  Copyright © 2017 Gopal Gupta. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class FriendGroupViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource {
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }

    @IBAction func createGroupButtonAction(_ sender: UIButton) {
        self.performSegue(withIdentifier : "createGroup" ,sender: self)
    }
    
    @IBOutlet weak var createGroubButton: UIButton!
    {
        didSet {
            createGroubButton.layer.borderWidth = 1
            createGroubButton.layer.masksToBounds = false
            createGroubButton.layer.borderColor = UIColor.white.cgColor
            createGroubButton.layer.cornerRadius = createGroubButton.frame.height/2
            createGroubButton.clipsToBounds = true
        }
    }
    @IBOutlet weak var friendGroupTableView: UITableView!
    
    var userIdString : String!
    var numberOfEvents : Int!
    var friendsListArray = [FriendGroupClass]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userid = defaults.string(forKey: "userId")
        self.userIdString = userid!
        print("self.userid \(self.userIdString)")
        
        self.friendGroupTableView.register(UINib(nibName : "FriendGroupCellType" ,bundle: nil), forCellReuseIdentifier: "friendGroupCellIdentifier")
        self.friendGroupListApi()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.friendGroupListApi()
    }
    
    
    func friendGroupListApi() {
        
        let url = "http://182.73.133.220/CruzSortMe/Apis/groupList"
        
        let paramter = ["user_id": self.userIdString!]
        
        Alamofire.request( url, method : .post  ,parameters : paramter).responseJSON { (responseObject) -> Void in
            
            print(responseObject)
            
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                
                let reMessage = resJson["res_msg"].string
                if reMessage == "Record  Found Successfully" {
                let dataResponse = resJson["CruzSortMe"].array
                
                self.numberOfEvents = dataResponse?.count
                print("numberofEvents \(self.numberOfEvents)")
                
                for eventArray in dataResponse! {
                    let eventArrayClass = FriendGroupClass()
                    
                    eventArrayClass.groupNameString = eventArray["group_name"].string
                    eventArrayClass.groupIdString = eventArray["id"].string
                    eventArrayClass.groupImageViewString = eventArray["group_img"].string
                    eventArrayClass.numberOfMembersString = eventArray["no_of_friend"].string
                    self.friendsListArray.append(eventArrayClass)
                }
                print("groupEventArray : \(self.friendsListArray)")
                print("dataArray \(dataResponse)")
                DispatchQueue.main.async {
                    self.friendGroupTableView.reloadData()
                }
                    
                }else {
                    self.friendGroupTableView.isHidden = true
                    let customLable = UILabel()
                    customLable.center.x = self.view.center.x
                    customLable.center.y = self.view.center.y
                    let parentClass = ParentClass()
                    self.view.addSubview(parentClass.setBlankView(label: customLable))
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
        
            return self.friendsListArray.count
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendGroupCellIdentifier")! as! FriendGroupCell
        
        let eventList = friendsListArray[indexPath.row]
        print("eventLsit\(eventList)")
        
        cell.groupNamelabel.text = eventList.groupNameString!
        cell.numberOfMemberLabel.text = "No of Members :" + eventList.numberOfMembersString!
        //        cell.friendNameLabel.text = eventList.friendNameString!
        //
        //        if shouldShowSearchResults {
        //            cell.textLabel?.text = marrFilteredFriendList[indexPath.row]
        //        }
        //        else {
        //            cell.textLabel?.text = friendsListArray[indexPath.row].friendNameString!
        //        }
        
        print("event imageString = \(eventList.groupImageViewString!)")
        let URL = NSURL(string: "\(eventList.groupImageViewString!)")
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
                        cell.friendGroupImageView.image = image
                    }
                    
                })
                
            }
        }
        
        
        //  self.IntrestIdString = eventList.interestId!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // let eventList = friendsListArray[indexPath.row]
      //  self.friendIdString = eventList.friendIdString!
        self.performSegue(withIdentifier: "friendDetail", sender: self)
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
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
