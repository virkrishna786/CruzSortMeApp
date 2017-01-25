//
//  ExploreViewController.swift
//  CruzSortMeApp
//
//  Created by Admin media on 1/20/17.
//  Copyright © 2017 Gopal Gupta. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class ExploreViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource ,UIPickerViewDataSource ,UIPickerViewDelegate {
    
    var boolValue = 0
    @IBAction func interestTypeButtonAction(_ sender: UIButton) {
        
        if boolValue == 0 {
            self.interestPickerView.isHidden = false
            boolValue = 1
        }else {
        self.interestPickerView.isHidden = true
            boolValue = 0
        }
    }
    var segmentButtonIndex : String!
    var categoryIdString : String!
    @IBAction func segmentButtonAction(_ sender: UISegmentedControl) {
        
        if segmnetButton.selectedSegmentIndex == 0 {
            self.segmentButtonIndex = "1"
            self.exploreDetailApiHit()
        }else {
            self.segmentButtonIndex = "2"
            self.exploreDetailApiHit()
        }
        
    }
    @IBOutlet weak var interestPickerView: UIPickerView!
    @IBOutlet weak var segmnetButton: UISegmentedControl!
    @IBAction func searchButtonAction(_ sender: UIButton) {
        self.segmentButtonIndex = "1"
        self.exploreDetailApiHit()
    }
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var InterestTypeButton: UIButton!
    let cellIdentifier = "eventDetail"
    let reviewCellIdentifier = "peopleCell"
    var numberofEvents :Int!
    var eventDetailArray = [EventDetailClass]()
    var peopleDetailArray = [ReviewClass]()
    var exploreDetailArray = [DatePickerClass]()
    @IBOutlet weak var eventDetailTableView: UITableView!
    var friendIdString : String!
    var eventIdStrings : String!
    
    var userIdString : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.interestPickerView.isHidden = true
        self.interestPickerView.delegate = self
        self.interestPickerView.dataSource = self
        self.eventDetailTableView.delegate = self
        self.eventDetailTableView.dataSource = self
        self.segmentButtonIndex = "1"
        
        let frames : CGRect = self.segmnetButton.frame
        self.segmnetButton.frame = CGRect(x: frames.origin.x, y: frames.origin.y, width: frames.size.width, height: 50)
        
        let useriDstring = defaults.string(forKey: "userId")
        self.userIdString = useriDstring!
        print("userid \(useriDstring!)")

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ExploreViewController.gestureFunction))
        self.view.addGestureRecognizer(tapGesture)
        
        self.navigationController?.navigationBar.isHidden = true
        self.eventDetailTableView.register(UINib(nibName : "EventTypeCell" ,bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.eventDetailTableView.register(UINib(nibName : "PeopleCellType" ,bundle: nil), forCellReuseIdentifier: reviewCellIdentifier)
        self.eventDetailTableView.isHidden = true
        self.interestTypeDetailApiHit()
        
        // Do any additional setup after loading the view.
    }
    
    func gestureFunction() {
        self.searchTextField.resignFirstResponder()
        self.interestPickerView.isHidden = true
        self.view.endEditing(true)
        
    }
    
    func interestTypeDetailApiHit() {
        
        if currentReachabilityStatus != .notReachable {
            
            let url = "\(baseUrl)exploreType"
            
            hudClass.showInView(view: self.view)
            
            Alamofire.request( url, method : .post).responseJSON { (responseObject) -> Void in
                
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
                            let eventArrayClass = DatePickerClass()
                         eventArrayClass.exploreId = eventArray["explore_id"].string
                         eventArrayClass.exploreName = eventArray["explore_name"].string
                            
                         self.exploreDetailArray.append(eventArrayClass)
                        }
                        print("dataArrayList \(dataResponse)")
                        
                        DispatchQueue.main.async {
                            self.interestPickerView.reloadAllComponents()
                        }
                        print("dsfs \(resJson)")
                    }else {
                        print("sdkgdksbhgks")
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
    
    
    // MARK:- picker View For Interest Type
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return exploreDetailArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return exploreDetailArray[row].exploreName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("exploredjsbf \(exploreDetailArray[row].exploreId)")
        self.InterestTypeButton.titleLabel?.text = exploreDetailArray[row].exploreName
        self.categoryIdString  = exploreDetailArray[row].exploreId
        
        print("categoryIdating \(self.categoryIdString!)")
        
        self.interestPickerView.isHidden = true
        
    }
    
    // MARK:- Api for search 
    
    
    func exploreDetailApiHit() {

        if currentReachabilityStatus != .notReachable {
            
            let url = "\(baseUrl)search"
            
            let parameter = ["explore_type" : "\(self.segmentButtonIndex!)",
                             "by_category" : "\(self.categoryIdString!)",
                             "search_key " : "\(self.searchTextField.text!)",
                             "user_id" : "\(self.userIdString!)"]
            print("parameter \(parameter)")
            hudClass.showInView(view: self.view)
            
            Alamofire.request( url, method : .post, parameters: parameter).responseJSON { (responseObject) -> Void in
                
                print(responseObject)
                
                print("rsposneIbekjds \(responseObject)")
                if responseObject.result.isSuccess {
                    hudClass.hide()
                    let resJson = JSON(responseObject.result.value!)
                    
                    print("resJsonf \(resJson)")
                    let  res_message  = (resJson["res_msg"].string)!
                    print("res_messafe \(res_message)")
                    
                    if res_message == "Record  Found Successfully" {
                        
                        if self.segmentButtonIndex == "1" {
                            
                            guard   let reviewData = resJson["CruzSortMe"].array else {
                                print("soemthing withds")
                                DispatchQueue.main.async {
                                    self.eventDetailTableView.isHidden = true
                                }
                                return
                            }
                            print("reviewDataArray  \(reviewData)")
                            for reviewArray in reviewData  {
                                let reviewClassArray = ReviewClass()
                                reviewClassArray.peopleIdString = reviewArray["id"].string
                                reviewClassArray.reviewerNameString = reviewArray["name"].string
                                reviewClassArray.userImageString = reviewArray["profile_image"].string
                                self.peopleDetailArray.append(reviewClassArray)
                                print("self.reviewDetailArray \(self.peopleDetailArray)")
                            }
                            
                            DispatchQueue.main.async {
                                self.eventDetailTableView.reloadData()
                                self.eventDetailTableView.isHidden = false
                            }
                            print("dsfs \(resJson)")
                            
                        }else if self.segmentButtonIndex == "2" {
                            
                            guard let dataResponse = resJson["CruzSortMe"].array else {
                                self.eventDetailTableView.isHidden = true
                                return
                            }
                            
                            self.numberofEvents = dataResponse.count
                            print("numberofEventsdetail \(self.numberofEvents)")
                            
                            for eventArray in dataResponse {
                                let eventArrayClass = EventDetailClass()
                                
                                eventArrayClass.eventImage = eventArray["event_banner"].string
                                eventArrayClass.eventDateString = eventArray["event_add_date"].string
                                eventArrayClass.eventIdString = eventArray["id"].string
                                eventArrayClass.numberOfReviewString = eventArray["no_of_review"].string
                                eventArrayClass.ratingString = eventArray["no_of_rating"].string
                                eventArrayClass.eventTimeString = eventArray["event_start_time"].string
                                eventArrayClass.eventName = eventArray["event_name"].string
                                eventArrayClass.eventEndTime = eventArray["event_end_time"].string
                                
                                //  eventArrayClass.reviewerNameString = eventArray
                                self.eventDetailArray.append(eventArrayClass)
                            }
                            
                            DispatchQueue.main.async {
                                self.eventDetailTableView.reloadData()
                                self.eventDetailTableView.isHidden = false

                            }
                            print("EventdetailArray : \(self.eventDetailArray)")
                            print("dataArrayList \(dataResponse)")
  
                        }
                        
                        
                    }else {
                        self.eventDetailTableView.isHidden = true
                        parentClass.setBlankView()
                        print("sdkgdksbhgks")
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
            hudClass.hide()
            parentClass.showAlert()
        }
    }
    
    
    // MARK:- table view data source and delegate method
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if segmentButtonIndex == "1" {
            
            print("peopleDetailArra \(peopleDetailArray.count)")
            if   peopleDetailArray.count <= 0  {
                return 0
            }else {
                return peopleDetailArray.count
            }
        } else if segmentButtonIndex == "2" {
            
            print("eventDetailArra \(eventDetailArray.count)")

            if   eventDetailArray.count <= 0  {
                return 0
            }else {
                return eventDetailArray.count
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //   return 400
        
        if segmentButtonIndex == "1" {
            return 100
        }else {
            return 450
        }
        
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        if segmentButtonIndex == "1" {
                let cell = tableView.dequeueReusableCell(withIdentifier: reviewCellIdentifier)! as! PeopleCell
                let eventList = peopleDetailArray[indexPath.row]
                print("eventLsit\(eventList)")
                
                print("event imageString = \(eventList.userImageString!)")
                let uRL = URL(string: "\(eventList.userImageString!)")
                cell.profileimageView.kf.setImage(with: uRL , placeholder : UIImage(named: "maleIcon"))
                
                cell.nameLabel.text =   eventList.reviewerNameString!
            
                return cell
        }else if segmentButtonIndex == "2" {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)! as! EventypeTableViewCell
            let eventList = eventDetailArray[indexPath.row]
            print("eventLsit\(eventList)")
            
            print("event imageString = \(eventList.eventImage!)")
            let uRL = URL(string: "\(eventList.eventImage!)")
            cell.eventImageView.kf.setImage(with: uRL , placeholder : UIImage(named: "dummy"))
            
            cell.eventTitleLabel.text =   eventList.eventName!
            cell.dateTimeLabel.text =   "Date:" + "" + eventList.eventDateString! + "" + "Timimg:" + "" + eventList.eventTimeString!
            cell.reviewButton.titleLabel?.text = eventList.numberOfReviewString!
            cell.ratingButton.titleLabel?.text = eventList.ratingString!
            return cell
        }
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if segmentButtonIndex ==  "1" {
            let eventList = peopleDetailArray[indexPath.row]
            self.friendIdString = eventList.peopleIdString!
            self.performSegue(withIdentifier: "friendDetail", sender: self)
        }else {
            
            let eventList = eventDetailArray[indexPath.row]
            self.eventIdStrings = eventList.eventIdString!
            self.performSegue(withIdentifier: "eventDetail", sender: self)
 
        }
        
        
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "friendDetail" {
            let eventDetailView = segue.destination as! FriendDetailViewController
            eventDetailView.friendIdString = self.friendIdString!
            print("homepage eventIDString \(eventDetailView.friendIdString)")
        }else  if segue.identifier == "eventDetail" {
            let eventDetailView = segue.destination as! EventDetailViewController
            // eventDetailView.delegate = self
            eventDetailView.eventIdString = self.eventIdStrings!
            print("homepage eventIDString \(eventDetailView.eventIdString)")
            
        }
        

        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
