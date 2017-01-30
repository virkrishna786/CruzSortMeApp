//
//  HomeViewController.swift
//  CruzSortMeApp
//
//  Created by Saurabh Mishra on 09/01/17.
//  Copyright © 2017 Gopal Gupta. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage
import Kingfisher


class HomeViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource , creatEventBackDelegate {
    
    var boolValue = 0
    var isNewDataLoading : Bool!

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBAction func createEventButttonAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "createEvent", sender: self)
    }
    
    @IBOutlet weak var createEventButton: UIButton!
    {
        didSet{
            createEventButton.layer.borderWidth = 1
            createEventButton.layer.masksToBounds = false
            createEventButton.layer.borderColor = UIColor.white.cgColor
            createEventButton.layer.cornerRadius = createEventButton.frame.height/2
            createEventButton.clipsToBounds = true
        }
    }
    @IBAction func intrestButtonAction(_ sender: UIButton) {
       // self.performSegue(withIdentifier: "friendList", sender: self)
    }
    
    let cellIdentifier = "postCellIdentifier"
    var  numberofEvents : Int!
    var eventIdString : String!

    var  homeEventArray = [HomeArrayClass]()
    @IBOutlet weak var postTableView: UITableView!
    @IBAction func buttonAction(_ sender: UIButton) {
   
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
   
    // MARK: - delegateMethod 
    
    func sendBoolValue(bool: Bool) {
        if bool == true {
            self.eventApiHit(string : "1")
        }
    }
    
    func eventApiHit(string : String) {
        
        if currentReachabilityStatus != .notReachable {
            
        hudClass.showInView(view: self.view)
        let url = "\(baseUrl)getAllEvent"
         
        hudClass.showInView(view: self.view)
        
        let parameter = ["end_value": "\(string)"]
        
        Alamofire.request( url, method : .post , parameters: parameter).responseJSON { (responseObject) -> Void in
            
            print(responseObject)
            
            if responseObject.result.isSuccess {
                self.postTableView.isHidden = false
                hudClass.hide()
                let resJson = JSON(responseObject.result.value!)
                
                let  res_message = resJson["res_msg"].string
                
                if res_message == "Record  Found Successfully" {
                    
                    
                let dataResponse = resJson["CruzSortMe"].array
                    
                    self.numberofEvents = dataResponse?.count
                    print("numberofEvents \(self.numberofEvents)")
                    
                    for eventArray in dataResponse! {
                        let eventArrayClass = HomeArrayClass()
                        
                        eventArrayClass.eventTitleString = eventArray["event_name"].string
                        eventArrayClass.eventImage = eventArray["event_banner"].string
                        eventArrayClass.dateTimeString = eventArray["event_add_date"].string
                        eventArrayClass.eventID = eventArray["id"].string
                        eventArrayClass.reviewString = eventArray["no_of_review"].string
                        eventArrayClass.ratingString = eventArray["no_of_rating"].string
                        eventArrayClass.eventStartTimimg = eventArray["event_start_time"].string
                        eventArrayClass.eventEndTiming = eventArray["event_end_time"].string
                        self.homeEventArray.append(eventArrayClass)
                    }
                    print("homeEventArray : \(self.homeEventArray)")
                    print("dataArray \(dataResponse)")
                }
                
                DispatchQueue.main.async {
                    self.postTableView.reloadData()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.postTableView.delegate = self
        self.postTableView.dataSource = self
        self.postTableView.backgroundColor = UIColor.clear
        self.postTableView.tableFooterView = UIView()

        self.isNewDataLoading = false
        
        let useriDstring = defaults.string(forKey: "userId")
        print("userid \(useriDstring!)")
        
        self.postTableView.register(UINib(nibName : "PostCell" ,bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.navigationController?.isNavigationBarHidden = false
        
        self.eventApiHit(string : "1")
        self.addChildViewController(appDelegate.menuTableViewController)

        // Do any additional setup after loading the view.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  homeEventArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 300
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)! as! PostCell
        let eventList = homeEventArray[indexPath.row]
        print("eventLsit\(eventList)")
        
        print("event imageString = \(eventList.eventImage!)")
        let url = URL(string : "\(eventList.eventImage!)")
        
        cell.eventImageView.kf.setImage(with: url , placeholder : UIImage(named: "dummy"))
        
        cell.dateTimeLabel.text = eventList.dateTimeString!
        cell.eventTitleLabel.text = eventList.eventTitleString!
        cell.ratingButton.titleLabel?.text = "\(eventList.ratingString!)/5"
        cell.reviewButton.titleLabel?.text = "\(eventList.reviewString!) reviews"
        cell.userIdLabel.text = eventList.eventID!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
         let eventList = homeEventArray[indexPath.row]
          self.eventIdString = eventList.eventID!
        self.performSegue(withIdentifier: "eventDetail", sender: self)
         print("eventIDString \(self.eventIdString!)")
        
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        //Bottom Refresh
        
        if scrollView == postTableView {
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
            {
                if !isNewDataLoading {
                        isNewDataLoading = true
                    eventApiHit(string : "2")
                    self.postTableView.reloadData()
                }
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
         if segue.identifier == "eventDetail" {
             let eventDetailView = segue.destination as! EventDetailViewController
                  // eventDetailView.delegate = self
              eventDetailView.eventIdString = self.eventIdString!
            print("homepage eventIDString \(eventDetailView.eventIdString)")
        
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
