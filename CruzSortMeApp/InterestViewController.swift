//
//  InterestViewController.swift
//  CruzSortMeApp
//
//  Created by Admin media on 1/11/17.
//  Copyright © 2017 Gopal Gupta. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

 var boolValueKey = 0

class InterestViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    
    @IBAction func menuButtonAction(_ sender: UIButton) {
        
        if boolValueKey == 0 {
            appDelegate.menuTableViewController.showMenu()
            self.view .addSubview(appDelegate.menuTableViewController.view)
            
            boolValueKey = 1
            
        } else {
            
            appDelegate.menuTableViewController.hideMenu()
            self.view .addSubview(appDelegate.menuTableViewController.view)
            boolValueKey = 0
        }

        
    }
 
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var staticLabel: UILabel!
    @IBAction func submitButtonAction(_ sender: UIButton) {
        
        DispatchQueue.global(qos: .background).async {
            self.selectedinterestApiHit(selectedArray: self.selectedInterestArray)
        }
        
 
    }
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var InterestTableView: UITableView!
    var InterestArray = [InterestArrayClass]()
    var IntrestIdString : String!
    var numberOfEvents : Int!
    var userIdString : String!
    var selectedInterestArray = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
    self.navigationController?.navigationBar.isHidden = true
        self.InterestTableView.delegate = self
        self.InterestTableView.dataSource = self
        
        self.staticLabel.isHidden = true
        let userid = defaults.string(forKey: "userId")
        self.userIdString = userid!
        print("self.userid \(self.userIdString)")
        
        self.InterestTableView.allowsMultipleSelection = true
        self.addChildViewController(appDelegate.menuTableViewController)

        DispatchQueue.global(qos: .background).async {
            self.interestApiHit()
        }

        
        // Do any additional setup after loading the view.
    }
    
    func interestApiHit() {
        
        let url = "http://182.73.133.220/CruzSortMe/Apis/listInterest"
        
        Alamofire.request( url, method : .post ).responseJSON { (responseObject) -> Void in
            
            print(responseObject)
            
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                
                let  res_message = resJson["res_msg"].string
                
                if res_message == "Record  Found Successfully" {
                    
                    let dataResponse = resJson["CruzSortMe"].array
                    
                    self.numberOfEvents = dataResponse?.count
                    print("numberofEvents \(self.numberOfEvents)")
                    
                    for eventArray in dataResponse! {
                        let eventArrayClass = InterestArrayClass()
                        
                        eventArrayClass.interestName = eventArray["interest_name"].string
                        eventArrayClass.interestId = eventArray["id"].string
                        self.InterestArray.append(eventArrayClass)
                    }
                    print("homeEventArray : \(self.InterestArray)")
                    print("dataArray \(dataResponse)")
                    DispatchQueue.main.async {
                        self.InterestTableView.reloadData()
                    }
                }else {
                    self.InterestTableView.isHidden = true
                    self.staticLabel.isHidden = false
                    self.staticLabel.text = "no interest found"
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
        return  InterestArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier")!
        cell.accessoryType = cell.isSelected ? .checkmark : .none
        cell.selectionStyle = .none // to prevent cells from being "highlighted"
        
//        let separatorView = UIView(frame: CGRect(x: 0, y: cell.contentView.frame.size.height-1, width: cell.contentView.frame.size.width, height: 10))
//        separatorView.backgroundColor = UIColor.red
//        cell.contentView.addSubview(separatorView)
        
//        
        let eventList = InterestArray[indexPath.row]
        print("eventLsit\(eventList)")
        
        cell.textLabel?.text  = eventList.interestName!
        self.IntrestIdString = eventList.interestId!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
            self.selectedInterestArray.append((cell.textLabel?.text)!)
            print(" selected cell \(cell.textLabel?.text)")
            print("selecgted \(self.selectedInterestArray)")
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
    }
    
    func selectedinterestApiHit(selectedArray : [String]) {
        
        let url = "http://182.73.133.220/CruzSortMe/Apis/saveInterest"
        
        let stringArray = selectedInterestArray
        let string = stringArray.joined(separator: ",")
        print("stringd \(string)")
        
        let parameter = ["interest_name" : string ,
                          "user_id" : self.userIdString!]
        
        print("parameter \(parameter)")
        
        
        Alamofire.request( url, method : .post , parameters: parameter ).responseJSON { (responseObject) -> Void in
            
            print(responseObject)
            
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                
                let  res_message = resJson["res_msg"].string
                
                if res_message == "Save Successfully" {
                    
                    let dataResponse = resJson["CruzSortMe"].array
                    
                    let alertVC = UIAlertController(title: "Alert", message: "Your interest has been saved successfully", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK",style:.default,handler: nil)
                    alertVC.addAction(okAction)
                    self.present(alertVC, animated: true, completion: nil)

                    print("dataArray \(dataResponse)")
                }else {

                    let alertVC = UIAlertController(title: "Alert", message: "Some thing went wrong", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK",style:.default,handler: nil)
                    alertVC.addAction(okAction)
                    self.present(alertVC, animated: true, completion: nil)
                }
                
                
            }
            if responseObject.result.isFailure {
                let error  = responseObject.result.error!  as NSError
                print("\(error)")
                
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
