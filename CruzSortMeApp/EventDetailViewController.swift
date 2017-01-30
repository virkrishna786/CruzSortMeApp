//
//  EventDetailViewController.swift
//  CruzSortMeApp
//
//  Created by Admin media on 1/11/17.
//  Copyright © 2017 Gopal Gupta. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class EventDetailViewController: UIViewController , ratingViewControllerDelegate , UITableViewDelegate ,UITableViewDataSource{

    
    @IBAction func postReviewButtonAction(_ sender: UIButton) {
        
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "ratingView") as! RatingAndReviewController
        vc.delegate = self
        vc.view.backgroundColor = color_app_backgroundView_trasnparent
        vc.modalPresentationStyle = UIModalPresentationStyle.custom
        present(vc, animated: true, completion: nil)
    }
    @IBOutlet weak var postReviewButton: UIButton!
    @IBAction func backButtonAction(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
        
    }
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var eventDetailTableView: UITableView!
    
    let cellIdentifier = "eventDetail"
    let reviewCellIdentifier = "reviewCell"
    var numberofEvents :Int!
    var eventIdString : String! {
        didSet {
            print("eventdetial eventIdString \(eventIdString!)")
        }
    }
    
    var eventDetailArray = [EventDetailClass]()
    var reviewDetailArray = [ReviewClass]()
     override func viewDidLoad() {
        super.viewDidLoad()
        self.eventDetailTableView.delegate = self
        self.eventDetailTableView.dataSource = self
        self.eventDetailTableView.tableFooterView = UIView()

        
        
        self.navigationController?.navigationBar.isHidden = true
        self.eventDetailTableView.register(UINib(nibName : "EventDetail" ,bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.eventDetailTableView.register(UINib(nibName : "ReviewCell" ,bundle: nil), forCellReuseIdentifier: reviewCellIdentifier)
        
       self.eventDetailApiHit()

//        DispatchQueue.global(qos: .background).async {
//            self.eventDetailApiHit()
//        }

        // Do any additional setup after loading the view.
    }
    
    func backFromRatingController(info: Bool) {
        
        print("krish")
    }
    
    func eventDetailApiHit() {
        
         if currentReachabilityStatus != .notReachable {
        
        let url = "http://182.73.133.220/CruzSortMe/Apis/eventDtail"
        
        let parameter = ["event_id" : "\(self.eventIdString!)"]
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
                    
                     let dataResponse = resJson["CruzSortMe"].array
                    
                    self.numberofEvents = dataResponse?.count
                    print("numberofEventsdetail \(self.numberofEvents)")
                    
                    for eventArray in dataResponse! {
                        let eventArrayClass = EventDetailClass()
                        
                        eventArrayClass.eventAddrss = eventArray["address"].string
                        eventArrayClass.eventImage = eventArray["event_banner"].string
                        eventArrayClass.eventDateString = eventArray["event_add_date"].string
                        eventArrayClass.eventIdString = eventArray["id"].string
                        eventArrayClass.numberOfReviewString = eventArray["no_of_review"].string
                        eventArrayClass.ratingString = eventArray["no_of_rating"].string
                        eventArrayClass.eventTimeString = eventArray["event_start_time"].string
                        eventArrayClass.eventName = eventArray["event_name"].string
                        eventArrayClass.eventDetailString = eventArray["description"].string
                        eventArrayClass.eventEndTime = eventArray["event_end_time"].string
                    
                      //  eventArrayClass.reviewerNameString = eventArray
                        self.eventDetailArray.append(eventArrayClass)
                    }
                    print("EventdetailArray : \(self.eventDetailArray)")
                    print("dataArrayList \(dataResponse)")
                    
                    guard   let reviewData = resJson["Rating"].array else {
                        print("soemthing withds")
                        DispatchQueue.main.async {
                            self.eventDetailTableView.reloadData()
                        }
                        return
                    }
                         print("reviewDataArray  \(reviewData)")
                       for reviewArray in reviewData  {
                        let reviewClassArray = ReviewClass()
                        reviewClassArray.reviewerNameString = reviewArray["username"].string
                        reviewClassArray.reviewDetail = reviewArray["review"].string
                        reviewClassArray.numberOfRating = reviewArray["rating"].string
                        reviewClassArray.userImageString = reviewArray["profile_image"].string
                        self.reviewDetailArray.append(reviewClassArray)
                        print("self.reviewDetailArray \(self.reviewDetailArray)")
                    }
                    
                    DispatchQueue.main.async {
                        self.eventDetailTableView.reloadData()
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
   

    func numberOfSections(in tableView: UITableView) -> Int {
        if reviewDetailArray.count <= 0 {
            
            return 1
        }else {
        
        return 2
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
     //   return eventDetailArray.count
        
        if   reviewDetailArray.count <= 0 {
            return eventDetailArray.count
        }else {
        switch section {
        case 0:
            print("eventdetailArray.count \(eventDetailArray.count)")
            return eventDetailArray.count
        case 1 :
            print("reviewDetailArray \(reviewDetailArray.count)")
            return reviewDetailArray.count
        default:
           return   1
        }
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
     //   return 400
        
        switch indexPath.section {
        case 0:
            return 400
        case 1:
            return 100
        default:
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        if reviewDetailArray.count <= 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)! as! EventDetailCell
            let eventList = eventDetailArray[indexPath.row]
            print("eventLsit\(eventList)")
            
            print("event imageString = \(eventList.eventImage!)")
            let uRL = URL(string: "\(eventList.eventImage!)")
            cell.eventImageView.kf.setImage(with: uRL , placeholder : UIImage(named: "dummy"))

            
            let eventAddress =  eventList.eventAddrss!
            if eventAddress == "" {
                cell.addresslabel.text = ""
            }else {
                cell.addresslabel.text =  "Address:" + "" + eventAddress
            }
            
            let eventnameString =  eventList.eventName!
            if eventAddress == "" {
                cell.eventNameLabel.text = ""
            }else {
                cell.eventNameLabel.text = eventnameString
            }
            
            let eventdetailData = eventList.eventDetailString!
            
            if eventdetailData == "" {
                cell.eventDetailLabel.text = ""
            }else {
                cell.eventDetailLabel.text = eventdetailData
            }
            
            cell.dateLabel.text =  "Date:" + "" + eventList.eventDateString!
            cell.timeLabel.text =  "Timimg:" + "" + eventList.eventTimeString
            
            return cell
        }else {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)! as! EventDetailCell
            let eventList = eventDetailArray[indexPath.row]
            print("eventLsit\(eventList)")
            
            print("event imageString = \(eventList.eventImage!)")
            let uRL = URL(string: "\(eventList.eventImage!)")
            cell.eventImageView.kf.setImage(with: uRL , placeholder : UIImage(named: "dummy"))
            
             let eventAddress =  eventList.eventAddrss!
             if eventAddress == "" {
                cell.addresslabel.text = ""
             }else {
            cell.addresslabel.text =  "Address:" + "" + eventAddress
            }
            
            let eventnameString =  eventList.eventName!
            if eventAddress == "" {
                cell.eventNameLabel.text = ""
            }else {
                cell.eventNameLabel.text = eventnameString
            }
            
            let eventdetailData = eventList.eventDetailString!
            
            if eventdetailData == "" {
                cell.eventDetailLabel.text = ""
            }else {
                cell.eventDetailLabel.text = eventdetailData
            }
            
            cell.dateLabel.text =  "Date:" + "" + eventList.eventDateString!
            cell.timeLabel.text =  "Timimg:" + "" + eventList.eventTimeString
            
            return cell
        case 1 :
            
            let cell = tableView.dequeueReusableCell(withIdentifier: reviewCellIdentifier)! as! ReviewTableViewCell
            let reviewList = reviewDetailArray[indexPath.row]
            print("eventLsit\(reviewList)")
            
            print("event imageString = \(reviewList.userImageString!)")
            let uRL = URL(string: "\(reviewList.userImageString!)")
            cell.profileImageView.kf.setImage(with: uRL , placeholder : UIImage(named: "dummy"))
            cell.nameLabel.text = reviewList.reviewerNameString!
            cell.reviewDetailLabel.text = reviewList.reviewDetail!
            cell.ratingLabel.text = reviewList.numberOfRating! + "/5"
            print("krish")

            return cell
        default:
            print("sadfas")
        }
        
        }
            return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ratingView" {
            let eventDetailView = segue.destination as! RatingAndReviewController
            eventDetailView.eventIDString = self.eventIdString!
            print("homepage eventIDString \(eventDetailView.eventIDString)")
            
        }

        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
