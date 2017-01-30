//
//  NotificationViewController.swift
//  CruzSortMeApp
//
//  Created by Admin media on 1/28/17.
//  Copyright © 2017 Gopal Gupta. All rights reserved.
//

import UIKit
import  Alamofire
import SwiftyJSON
import AlamofireImage

class NotificationViewController: UIViewController , UITableViewDelegate ,UITableViewDataSource {
    
    var boolValue = 0
    
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
    @IBOutlet weak var eventDetailTableView: UITableView!
    let cellIdentifier = "whoseAroundEventCell"
    let reviewCellIdentifier = "whoseAroundPeopleCell"
    var numberofEvents :Int!
    var eventDetailArray = [EventDetailClass]()
    var peopleDetailArray = [ReviewClass]()
    var userIdString : String!
    var friendIdString : String!
    var  exploreDetailArray = [WhoseAroundDataClass]()
    var peopleIdString : String!
    var eventIdString : String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.eventDetailTableView.delegate = self
        self.eventDetailTableView.dataSource = self
        
        let useriDstring = defaults.string(forKey: "userId")
        self.userIdString = useriDstring!
        print("userid \(useriDstring!)")
        
        self.eventDetailTableView.register(UINib(nibName : "WhoseAroundPeopleTableViewCell" ,bundle: nil), forCellReuseIdentifier: reviewCellIdentifier)
        self.eventDetailTableView.register(UINib(nibName : "WhoseAroundEventTableViewCell" ,bundle: nil), forCellReuseIdentifier: cellIdentifier)

        self.addChildViewController(appDelegate.menuTableViewController)
        self.eventDetailTableView.tableFooterView = UIView()
        
        self.whoseAroundApiHit()


        // Do any additional setup after loading the view.
    }
    
    
    func whoseAroundApiHit() {
        
        if currentReachabilityStatus != .notReachable {
            
            let parameter = ["user_id" : "\(self.userIdString!)"
            ]
            
            let url = "\(baseUrl)notificationGet"
            
            hudClass.showInView(view: self.view)
            
            Alamofire.request( url, method : .post , parameters : parameter).responseJSON { (responseObject) -> Void in
                
                print(responseObject)
                
                print("rsposneIbekjds \(responseObject)")
                if responseObject.result.isSuccess {
                    hudClass.hide()
                    let resJson = JSON(responseObject.result.value!)
                    
                    print("resJsonf \(resJson)")
                    let  res_message  = (resJson["res_msg"].string)!
                    print("res_messafe \(res_message)")
                    
                    if res_message == "Record  Found Successfully" {
                        let dataResponse = resJson["CruzSortMe"].array
                        
                        self.numberofEvents = dataResponse?.count
                        print("numberofEventsdetail \(self.numberofEvents)")
                        
                        for eventArray in dataResponse! {
                            let eventArrayClass = WhoseAroundDataClass()
                            
                            eventArrayClass.eventIdString = eventArray["id"].string
                            eventArrayClass.eventNmaeString = eventArray["name"].string
                            eventArrayClass.eventImageString = eventArray["image"].string
                            eventArrayClass.distanceStringForEventString = eventArray["notification_message"].string
                            eventArrayClass.cateogoryString = eventArray["category"].string
                            
                            self.exploreDetailArray.append(eventArrayClass)
                        }
                        print("dataArrayList \(dataResponse)")
                        
                        DispatchQueue.main.async {
                            self.eventDetailTableView.reloadData()
                        }
                        print("dsfs \(resJson)")
                    }else {
                        print("sdkgdksbhgks")
                        self.eventDetailTableView.isHidden = true
                        let label = UILabel()
                        self.view.addSubview(parentClass.setBlankView(label: label))
                    }
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
        
        return exploreDetailArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        let eventdata = exploreDetailArray[indexPath.row]
        let eventCategoryString = eventdata.cateogoryString!
        
        print("eventCategoryString : \(eventCategoryString)")
        
        if eventCategoryString == "People" {
            let cell = tableView.dequeueReusableCell(withIdentifier: reviewCellIdentifier)! as! WhoseAroundPeopleCell
            cell.nameLabel.text = eventdata.eventNmaeString!
            cell.distanceLabel.text = eventdata.distanceStringForEventString!
            cell.categoryLabel.text = "Person"
            let uRL = URL (string: "\(eventdata.eventImageString!)")
            cell.profileImageView.kf.setImage(with: uRL , placeholder : UIImage(named: "aboutUs"))
            
            return cell
        } else  if eventCategoryString == "Event"{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)! as! WhoseAroundEventTableViewCell
            cell.eventNameLabel.text = eventdata.eventNmaeString!
            cell.eventDistanceLabel.text = eventdata.distanceStringForEventString!
            cell.categoryLabel.text = "Event"
            let uRL = URL (string: "\(eventdata.eventImageString!)")
            cell.eventImageView.kf.setImage(with: uRL , placeholder : UIImage(named: "aboutUs"))
            
            return cell
        }else {
            
            return cell
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let eventdata = exploreDetailArray[indexPath.row]
        let eventCategoryString = eventdata.cateogoryString!
        
        print("eventCategoryString : \(eventCategoryString)")
        
        if eventCategoryString == "People" {
            self.peopleIdString = eventdata.eventIdString!
            self.performSegue(withIdentifier: "friendDetail", sender: self)
            
        }else  if eventCategoryString == "Event" {
            
            self.eventIdString = eventdata.eventIdString!
            self.performSegue(withIdentifier: "eventDetail", sender: self)
            
            
            
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
