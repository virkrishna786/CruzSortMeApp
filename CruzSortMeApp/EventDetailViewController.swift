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

class EventDetailViewController: UIViewController , UITableViewDelegate ,UITableViewDataSource{

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
        
        self.navigationController?.navigationBar.isHidden = false
        self.eventDetailTableView.register(UINib(nibName : "EventDetail" ,bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.eventDetailTableView.register(UINib(nibName : "ReviewTableViewCell" ,bundle: nil), forCellReuseIdentifier: reviewCellIdentifier)

        

        
     //   print("self.eventIdString \(self.eventIdString!)")

        DispatchQueue.global(qos: .background).async {
            self.eventDetailApiHit()
        }

        // Do any additional setup after loading the view.
    }
    
    func eventDetailApiHit() {
        
        let url = "http://182.73.133.220/CruzSortMe/Apis/eventDtail"
        
        let parameter = ["event_id" : "3"]
        print("parameter \(parameter)")
        
        Alamofire.request( url, method : .get, parameters: parameter).responseJSON { (responseObject) -> Void in
            
            print(responseObject)
            
            print("rsposneIbekjds \(responseObject)")
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                
                print("resJson \(resJson)")
                let  res_message = resJson["res_msg"].string
                
                if res_message == "Record Found Successfully" {
                    
                     let dataResponse = resJson["CruzSortMe"].array
                    
                    self.numberofEvents = dataResponse?.count
                    print("numberofEvents \(self.numberofEvents)")
                    
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
                    print("homeEventArray : \(self.eventDetailArray)")
                    print("dataArray \(dataResponse)")
                    
//                    let reviewData = resJson["Rating"].array
//                         print("reviewDataArray  \(reviewData)")
//                     for reviewArray in reviewData!   {
//                        let reviewClassArray = ReviewClass()
//                        reviewClassArray.reviewerNameString = reviewArray["username"].string
//                        reviewClassArray.reviewDetail = reviewArray["review"].string
//                        reviewClassArray.numberOfRating = reviewArray["rating"].string
//                        reviewClassArray.userImageString = reviewArray["profile_image"].string
//                        self.reviewDetailArray.append(reviewClassArray)
//                    }
//                    
                    
                }
                
                DispatchQueue.main.async {
                    self.eventDetailTableView.reloadData()
                }
                print("dsfs \(resJson)")
            }
            if responseObject.result.isFailure {
                let error  = responseObject.result.error!  as NSError
                print("\(error)")
            }
        }
    }
   
//    
//    "Rating" : [
//    {
//    "username" : "krishna",
//    "id" : "2",
//    "profile_image" : "http:\/\/182.73.133.220\/CruzSortMe\/images\/temp\/dumi_profile_pic.jpeg",
//    "user_id" : "18",
//    "review" : "Lorem Ipsum copy in various charsets and languages for layouts.",
//    "rating" : "4"
//},


    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return eventDetailArray.count
        
//        switch section {
//        case 0:
//            print("eventdetailArray.count \(eventDetailArray.count)")
//            return eventDetailArray.count
//        case 1 :
//            print("reviewDetailArray \(reviewDetailArray.count)")
//            return reviewDetailArray.count
//        default:
//           return   1
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            return 400
        case 1:
            return 200
        default:
            return 400
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)! as! EventDetailCell
            let eventList = eventDetailArray[indexPath.row]
            print("eventLsit\(eventList)")
            
            print("event imageString = \(eventList.eventImage!)")
            let URL = NSURL(string: "\(eventList.eventImage!)")
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
                            cell.eventImageView.image = image
                        }
                        
                    })
                    
                }
            }
            
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
            
//            let cell = tableView.dequeueReusableCell(withIdentifier: reviewCellIdentifier)! as! ReviewTableViewCell
//            let reviewList = reviewDetailArray[indexPath.row]
//            print("eventLsit\(reviewList)")
//            
//            print("event imageString = \(reviewList.userImageString!)")
//            let URL = NSURL(string: "\(reviewList.userImageString!)")
//            print("urlsfgds \(URL)")
//            let mutableUrlRequest = NSMutableURLRequest(url: URL! as URL)
//            mutableUrlRequest.httpMethod = "get"
//            
//            mutableUrlRequest.setValue("image/jpeg", forHTTPHeaderField: "Accept")
//            
//            
//            let headers = [
//                "Accept"  :  "image/jpeg"
//            ]
//            print(" headers \(headers)")
//            print("mutable Request : \(mutableUrlRequest)")
//            //  request.addAcceptableImageContentTypes(["image/jpeg"])
//            
//            Alamofire.request("\(URL!)").responseImage { response in
//                debugPrint(response)
//                
//                print("adsfdfs \(response.request!)")
//                print("dskjfd \(response.response!)")
//                print(" response.result \(response.result)")
//                
//                if let image = response.result.value {
//                    DispatchQueue.global().async(execute: {
//                        
//                        if let cellToUpdate = tableView.cellForRow(at: indexPath) {
//                            
//                            print("\(cellToUpdate)")
//                            cell.profileImageView.image = image
//                        }
//                        
//                    })
//                    
//                }
//            }
//
//            cell.nameLabel.text = reviewList.reviewerNameString!
//            cell.reviewDetailLabel.text = reviewList.reviewDetail!
//            cell.ratingLabel.text = reviewList.numberOfRating! + "/5"
//            
//            return cell
                print("krish")
        default:
            print("sadfas")
        }
        
        return cell
    }
    
//    
//    "Rating" : [
//    {
//    "username" : "krishna",
//    "id" : "2",
//    "profile_image" : "http:\/\/182.73.133.220\/CruzSortMe\/images\/temp\/dumi_profile_pic.jpeg",
//    "user_id" : "18",
//    "review" : "Lorem Ipsum copy in various charsets and languages for layouts.",
//    "rating" : "4"
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
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
