//
//  GroupDetailViewController.swift
//  CruzSortMeApp
//
//  Created by Admin media on 1/20/17.
//  Copyright © 2017 Gopal Gupta. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class GroupDetailViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource {
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var groupDetailTableView: UITableView!
    @IBOutlet weak var  groupImageView: UIImageView!{
        didSet{
            groupImageView.layer.borderWidth = 1
            groupImageView.layer.masksToBounds = false
            groupImageView.layer.borderColor = UIColor.white.cgColor
            groupImageView.layer.cornerRadius = groupImageView.frame.height/2
            groupImageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var groupNameLabel: UILabel!
   
    @IBOutlet weak var noOfLabels: UILabel!
    
    let cellIdentifier = "groupDetailCellIdentier"
    var groupClassArray = [GroupDetailClass]()
     var friendIdString : String!
    var userIdString : String!
    var numberOfEvents : Int!
    var groupIdString : String!
    var previousGroupId : String!
    {
        didSet {
            
            print("previos uds \(previousGroupId)")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

          self.groupDetailTableView.register(UINib(nibName : "GroupDetailCell" ,bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.groupFriendListApi()
        // Do any additional setup after loading the view.
    }
    
    func groupFriendListApi() {
        
        if currentReachabilityStatus != .notReachable {

        
        let url = "\(baseUrl)groupDetail"

        
        let paramter = ["group_id": self.previousGroupId!]
        hudClass.showInView(view: self.view)
            
        Alamofire.request( url, method : .post  ,parameters : paramter).responseJSON { (responseObject) -> Void in
            
            print(responseObject)
            
            hudClass.hide()
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                
                let  res_message = resJson["res_msg"].string
                if res_message == "Record  Found Successfully" {
                
                self.groupIdString = resJson["g_id"].string
                self.groupNameLabel.text = "GroupName : \(resJson["group_name"].string)"
                self.noOfLabels.text =  "No of members :\(resJson["no_of_friend"].string)"
                self.downloadImage(string: (resJson["group_img"].string)!)
                let dataResponse = resJson["CruzSortMe"].array
                    
                for eventArray in dataResponse! {
                    let eventArrayClass = GroupDetailClass()
                    
                    eventArrayClass.groupFriendNameString = eventArray["username"].string
                    //eventArrayClass.groupIdString = eventArray["friend_id"].string
                    eventArrayClass.groupFriendImageViewString = eventArray["user_img"].string
                    self.groupClassArray.append(eventArrayClass)
                }
                print("homeEventArray : \(self.groupClassArray)")
                print("dataArray \(dataResponse)")
                DispatchQueue.main.async {
                    self.groupDetailTableView.reloadData()
                }
                    
                }else {
                    self.groupDetailTableView.isHidden = true
                    let parentClass = ParentClass()
                    self.view.addSubview(parentClass.setBlankView())
                }
                print("dsfs \(resJson)")
            }
            if responseObject.result.isFailure {
                hudClass.hide()
                parentClass.showAlertWithApiFailure()
                let error  = responseObject.result.error!  as NSError
                print("\(error)")
                
            }
        }
        }else{
            parentClass.showAlert()
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return self.groupClassArray.count
        
      }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)! as! GroupDetailCellType
        
        let eventList = groupClassArray[indexPath.row]
        print("eventLsit\(eventList)")
        
              cell.groupFriendNameLabel.text = eventList.groupFriendNameString!
        
        print("event imageString = \(eventList.groupFriendImageViewString!)")
        let URL = NSURL(string: "\(eventList.groupFriendImageViewString!)")
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
                        cell.groupFriendImageView.image = image
                    }
                    
                })
                
            }
        }
        
        
        //  self.IntrestIdString = eventList.interestId!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let eventList = groupClassArray[indexPath.row]
        self.friendIdString = eventList.groupIdString!
        self.performSegue(withIdentifier: "friendDetail", sender: self)
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
    func downloadImage(string: String) {
        
        
        let URL = NSURL(string: "\(string)")
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
                    
                    self.groupImageView.image = image
                    
                })
                
            }
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
