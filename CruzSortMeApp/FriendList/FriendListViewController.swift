//
//  FriendListViewController.swift
//  CruzSortMeApp
//
//  Created by Admin media on 1/13/17.
//  Copyright © 2017 Gopal Gupta. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON


class FriendListViewController: UIViewController ,UITableViewDataSource ,UITableViewDelegate , UISearchBarDelegate ,UISearchDisplayDelegate  ,UISearchControllerDelegate {
    
    @IBOutlet weak var createGroupButton: UIButton!{
        didSet{
            self.createGroupButton.layer.cornerRadius = 30
        }
    }
    @IBAction func createGroupButtonAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "friendGroup", sender: self)
        
    }
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
    var userIdString : String!
    var numberOfEvents : Int!
    @IBOutlet weak var friendSearchBar: UISearchBar!
    @IBOutlet weak var friendListTableView: UITableView!
    
    var marrFilteredFriendList = [FriendListClass]()
    var shouldShowSearchResults = false
    
    var searchController: UISearchController!
    
    var customSearchController: CustomSearchController!
    
    var friendIdString : String!
    let cellIdentifier = "friendListCellTypee"
    
    var searchActive : Bool = false
    var friendsListArray = [FriendListClass]()
    var filteredFriendListArray = [FriendListClass]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.friendListTableView.delegate = self
        self.friendListTableView.dataSource = self
        self.friendSearchBar.delegate = self
        let userid = defaults.string(forKey: "userId")
        self.userIdString = userid!
        print("self.userid \(self.userIdString)")
        
         self.friendListTableView.register(UINib(nibName : "FriendListCell" ,bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        self.addChildViewController(appDelegate.menuTableViewController)
        DispatchQueue.global(qos: .background).async {
            self.friendListApi()
        }
        

        // Do any additional setup after loading the view.
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
//        filteredFriendListArray = friendsListArray.filter({ (text  as FriendListClass).friendNameString as! String -> Bool in
//            let tmp: NSString = text
//            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
//            return range.location != NSNotFound
//        })
        
        
        filteredFriendListArray = friendsListArray.filter() {
            if let type = ($0 as FriendListClass).friendNameString as String! {
                return type.range(of: searchText, options: NSString.CompareOptions.caseInsensitive) != nil
            } else {
                return false
            }        }
        if(filteredFriendListArray.count == 0){
            searchActive = false
        } else {
            searchActive = true
        }
        self.friendListTableView.reloadData()
    }

    
    
    func friendListApi() {
         if currentReachabilityStatus != .notReachable {
        
        let url = "\(baseUrl)friendList"
        
        let paramter = ["user_id": self.userIdString!]
        
        Alamofire.request( url, method : .post  ,parameters : paramter).responseJSON { (responseObject) -> Void in
            
            print(responseObject)
            
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                
                    let dataResponse = resJson["Friend"].array
                    
                    self.numberOfEvents = dataResponse?.count
                    print("numberofEvents \(self.numberOfEvents)")
                    
                    for eventArray in dataResponse! {
                        let eventArrayClass = FriendListClass()
                        
                        eventArrayClass.friendNameString = eventArray["username"].string
                        eventArrayClass.friendIdString = eventArray["friend_id"].string
                        eventArrayClass.friendProfileImage = eventArray["profile_image"].string
                        self.friendsListArray.append(eventArrayClass)
                    }
                    print("homeEventArray : \(self.friendsListArray)")
                    print("dataArray \(dataResponse)")
                    DispatchQueue.main.async {
                        self.friendListTableView.reloadData()
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
      
        if(searchActive) {
            return self.filteredFriendListArray.count
        }
        return self.friendsListArray.count
        
       // return self.friendsListArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)! as! FriendListCellType
     //   var friendName : String!

        let eventList = friendsListArray[indexPath.row]
        print("eventLsit\(eventList)")
        
        if(searchActive){
            cell.friendNameLabel?.text = filteredFriendListArray[indexPath.row].friendNameString
            let uRL = URL(string: "\(filteredFriendListArray[indexPath.row].friendProfileImage!)")
            print("urlsfgds \(uRL)")
            cell.friendProfileImageView.kf.setImage(with: uRL! ,placeholder : UIImage(named: "aboutUs"))
        } else {
            cell.friendNameLabel?.text = friendsListArray[indexPath.row].friendNameString
            let uRL = URL(string: "\(friendsListArray[indexPath.row].friendProfileImage!)")
            print("urlsfgds \(uRL)")
            cell.friendProfileImageView.kf.setImage(with: uRL! ,placeholder : UIImage(named: "aboutUs"))
        }

        

      // cell.friendNameLabel.text = eventList.friendNameString!
       // print("event imageString = \(eventList.friendProfileImage!)")
//        let uRL = URL(string: "\(eventList.friendProfileImage!)")
//        print("urlsfgds \(uRL)")
//        cell.friendProfileImageView.kf.setImage(with: uRL! ,placeholder : UIImage(named: "aboutUs"))
        
      //  self.IntrestIdString = eventList.interestId!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                  let eventList = friendsListArray[indexPath.row]
                  let fileteredList = filteredFriendListArray[indexPath.row]
        if (searchActive) {
            self.friendIdString = fileteredList.friendIdString!
            self.performSegue(withIdentifier: "friendDetail", sender: self)

            
        }else {
        
            self.friendIdString = eventList.friendIdString!
            self.performSegue(withIdentifier: "friendDetail", sender: self)
        }

    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
       
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func filterTableViewForEnterText(_ searchText: String) {
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchText)
        
        let array = (self.marrFilteredFriendList as NSArray).filtered(using: searchPredicate)
        self.marrFilteredFriendList = array as! [FriendListClass]
        self.friendListTableView.reloadData()
    }
    
    
    
 
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "friendDetail" {
            let eventDetailView = segue.destination as! FriendDetailViewController
            eventDetailView.friendIdString = self.friendIdString!
            print("homepage eventIDString \(eventDetailView.friendIdString)")
        }

        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
}
