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
            print("eventIdString \(eventIdString)")
        }
    }
    
    var eventDetailArray = [EventDetailClass]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.eventDetailTableView.delegate = self
        self.eventDetailTableView.dataSource = self
        
        print("self.eventArray \(self.eventIdString)")

        // Do any additional setup after loading the view.
    }
    
    func eventDetailApiHit() {
        
        let url = "http://182.73.133.220/CruzSortMe/Apis/getAllEvent"
        
        Alamofire.request( url, method : .get ).responseJSON { (responseObject) -> Void in
            
            print(responseObject)
            
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                
                let  res_message = resJson["res_msg"].string
                
                if res_message == "Record  Found Successfully" {
                    
                     let dataResponse = resJson["CruzSortMe"].array
                    
                    self.numberofEvents = dataResponse?.count
                    print("numberofEvents \(self.numberofEvents)")
                    
                    for eventArray in dataResponse! {
                        let eventArrayClass = EventDetailClass()
                        
                        eventArrayClass.eventAddrss = eventArray["event_address"].string
                        eventArrayClass.eventImage = eventArray["event_banner"].string
                        eventArrayClass.eventDateString = eventArray["event_add_date"].string
                        eventArrayClass.eventIdString = eventArray["id"].string
                        eventArrayClass.numberOfReviewString = eventArray["no_of_review"].string
                        eventArrayClass.ratingString = eventArray["no_of_rating"].string
                        eventArrayClass.eventTimeString = eventArray["event_start_time"].string
                        self.eventDetailArray.append(eventArrayClass)
                    }
                    print("homeEventArray : \(self.eventDetailArray)")
                    print("dataArray \(dataResponse)")
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

    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       return 5
      //  return  eventDetailArray.count
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
            //        cell.dateTimeLabel.text = eventList.dateTimeString!
            //        cell.eventTitleLabel.text = eventList.eventTitleString!
            //        cell.ratingButton.titleLabel?.text = "\(eventList.ratingString!)/5"
            //        cell.reviewButton.titleLabel?.text = "\(eventList.reviewString!) reviews"
            //        
            return cell
        case 1 :
                print("krish")
        default:
            print("sadfas")
        }
        
        return cell
    }
    
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
