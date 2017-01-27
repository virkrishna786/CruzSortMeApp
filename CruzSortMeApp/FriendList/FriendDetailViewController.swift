//
//  FriendDetailViewController.swift
//  CruzSortMeApp
//
//  Created by Admin media on 1/16/17.
//  Copyright © 2017 Gopal Gupta. All rights reserved.
//

import UIKit
import  Alamofire
import AlamofireImage
import SwiftyJSON

class FriendDetailViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource {
    
    @IBAction func backButtonAction(_ sender: UIButton) {
          _ = navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var friendDetailTableView: UITableView!
    @IBOutlet weak var friendNameLabel: UILabel!
    @IBOutlet weak var friendProfileImageView: UIImageView!
    var friendEventDetailArray = [FriendDetailClass]()
    let cellIdentifier = "friendDetailCellIdentifier"
   
    
    var friendIdString : String! {
        didSet {
        
        }
    }
    var numberofEvents : Int!
    var userIdString: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let userid = defaults.string(forKey: "userId")
        self.userIdString = userid!
        print("self.userid \(self.userIdString)")
        
         self.friendDetailTableView.register(UINib(nibName : "FriendDetailCell" ,bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.friendDetailApiHit()
               // Do any additional setup after loading the view.
    }
    
    func friendDetailApiHit() {
        
         if currentReachabilityStatus != .notReachable {
        
        let url = "\(baseUrl)friendProfile"
        
        let parameter = ["friend_id": self.friendIdString!,
                         "user_id" : self.userIdString!]
            hudClass.showInView(view: self.view)
        
        Alamofire.request( url, method : .post , parameters: parameter).responseJSON { (responseObject) -> Void in
            
            print(responseObject)
            
            if responseObject.result.isSuccess {
                hudClass.hide()

                let resJson = JSON(responseObject.result.value!)
                
                let  res_message = resJson["res_msg"].string
                if res_message == "Record  Found Successfully" {
                    
                    guard   let friendDetailDict = resJson["friendDetail"].dictionary else {
                       print("no data friend array")
                        return
                    }
                    self.friendNameLabel.text = friendDetailDict["username"]!.string
                    self.downloadImage(string: (friendDetailDict["profile_image"]!.string)!)
                    
                    
                    guard   let dataResponse = resJson["CruzSortMe"].array else {
                        
                        print("no data in friend evnt")
                        return
                    }
                
                    self.numberofEvents = (dataResponse.count)
                    print("numberoffriendEvents \(self.numberofEvents)")
                    
                    for eventArray in dataResponse {
                        let eventArrayClass = FriendDetailClass()
                        eventArrayClass.friendEventDetailImageString = eventArray["event_banner"].string
                        eventArrayClass.friendIdString = eventArray["id"].string
                        eventArrayClass.friendEventReviewString = eventArray["no_of_review"].string
                        eventArrayClass.friendEventRatingString = eventArray["no_of_rating"].string
                        eventArrayClass.friendEventAddDateString = eventArray["event_start_time"].string
                        eventArrayClass.friendEventEndTimeString = eventArray["event_end_time"].string
                        eventArrayClass.friendEventNameString = eventArray["event_name"].string
                        self.friendEventDetailArray.append(eventArrayClass)
                    }
                    print("homeEventArray : \(self.friendEventDetailArray)")
                    print("dataArray \(dataResponse)")
                    DispatchQueue.main.async {
                        self.friendDetailTableView.reloadData()
                    }
                    print("dsfs \(resJson)")
                }else {
                    self.friendDetailTableView.isHidden = true
                    let parentClass = ParentClass()
                    self.view.addSubview(parentClass.setBlankView())
                }
            }
            if responseObject.result.isFailure {
                hudClass.hide()
                parentClass.showAlertWithApiFailure()
                let error  = responseObject.result.error!  as NSError
                print("failuredata \(error)")
            }
        }
         }else {
            parentClass.showAlert()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("friendEvent deatil Array \(friendEventDetailArray.count)")
        return  friendEventDetailArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)! as! FriendDetailCellType
        let eventList = friendEventDetailArray[indexPath.row]
        print("edsfsftLsit\(eventList)")
        
        print("event imageString = \(eventList.friendEventDetailImageString!)")
        let uRL = URL(string: "\(eventList.friendEventDetailImageString!)")
        print("urlsfgds \(uRL)")
        cell.freindEventImageView.kf.setImage(with: uRL , placeholder : UIImage(named: "dummy"))
        
        cell.friendEventTimeLabel.text = eventList.friendEventAddDateString! + "|" + eventList.friendEventEndTimeString!
        cell.friendEventDetail.text = eventList.friendEventNameString!
        cell.friendEventRatingButton.titleLabel?.text = "\(eventList.friendEventRatingString!)/5"
        cell.friendEventReviewButton.titleLabel?.text = "\(eventList.friendEventReviewString!) reviews"
      //  cell.friendDetailEventIdString.text = eventList.friende!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let eventList = homeEventArray[indexPath.row]
//        self.eventIdString = eventList.eventID!
//        self.performSegue(withIdentifier: "eventDetail", sender: self)
//        print("eventIDString \(self.eventIdString!)")
        
        
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
                    
                self.friendProfileImageView.image = image
                    
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
