//
//  MenuTVC.swift
//  MyRentApp
//
//  Created by Saurabh  on 7/6/15.
//  Copyright (c) 2015 Dogma Systems. All rights reserved.
//

import UIKit
import  Alamofire
import  SwiftyJSON

class MenuTVC: UITableViewController {
 
    let LeftMenuWidth = 100.0
    var headerView:UIView?
    var  imageIcon=UIImageView()
    var SA_Choice = ["Home","Account","My Events","Interest","Explore","Friends","Friend Request","Messages","Around","Calender","About Us","Logout"]
    var SA_Icons = ["home","account","myEvent","myEvent","search","group","request","message","search","calender","aboutUs","account"]
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view .backgroundColor=UIColor.black.withAlphaComponent(0.8)
        tableView.dataSource = self
        tableView.delegate = self
        //MenuTVC .frame.size.height=800
        tableView.isScrollEnabled=true
        headerView=UIView()
        setTableviewHeader()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        DispatchQueue.main.async(){
            //code
            self.tableView.reloadData()
        }
    }
    
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(true)
//        tableView.reloadData()
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setTableviewHeader(){
        //let headerView=UIView()
        headerView!.frame=CGRect(x: 0, y: 0, width: 100, height: 150)//CGRect(0, 0, 220, 200)
        
        
        imageIcon.frame=CGRect(x: 10, y: 5, width: 80, height: 80)//CGRect(53,9,150,145)
        imageIcon.layer.borderWidth = 1
        imageIcon.layer.masksToBounds = false
        imageIcon.layer.borderColor = UIColor.white.cgColor
        imageIcon.layer.cornerRadius = imageIcon.frame.height/2
        imageIcon.clipsToBounds = true

        
        let imageString = defaults.string(forKey: "profile_image")
        self.downloadImage(string: imageString!)
        imageIcon.contentMode = .scaleAspectFit
        let nameLabel=UILabel()
        nameLabel.frame=CGRect(x: 10, y: 100 , width:85, height:30)//CGRectMake(60,150, 85, 30)
        
        let username = defaults.string(forKey: "user_name")
        print("userNamde : \(username)")
        nameLabel.text = username
        nameLabel.textColor = UIColor.white
        nameLabel.textAlignment = NSTextAlignment.center
        headerView!.backgroundColor=UIColor.white.withAlphaComponent(0.5)
        headerView!.addSubview(imageIcon)
        headerView?.addSubview(nameLabel)
        headerView!.clipsToBounds=true
        self.tableView.tableHeaderView=headerView
        
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("asjkhask \(SA_Choice.count)")
        return SA_Choice.count

    }
    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete method implementation.
//        // Return the number of rows in the section.
//        
//        print("hjgjhg \(SA_Choice.count)")
//        return SA_Choice.count
//    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        
//        return 75
//    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("sadjksdshsd")

        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier")!
        print("sadjkhsd")
        // Configure the cell...
        tableView.separatorStyle=UITableViewCellSeparatorStyle.singleLine
        cell.backgroundColor=UIColor.white
        cell.textLabel?.textColor=UIColor.darkGray
        cell.textLabel?.font=UIFont (name: "Helvetica Neue", size: 15)
        cell.textLabel!.text=SA_Choice[indexPath.row]
        //icons
        cell.imageView?.image=UIImage(named:(SA_Icons[indexPath.row] as String))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("dkdakshgasjkga")
        
        if (indexPath.row == 0) {
            
            hideMenu()
           let firstView:HomeViewController
            = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "homeView") as! HomeViewController
            //            let firstView:HomeViewController = HomeViewController(nibName:"HomeViewController",bundle:Bundle.main)
            var fcheck=Bool()
            fcheck=false
            let viewArray=self.navigationController?.viewControllers as NSArray!
            if((viewArray) != nil){
                if !((viewArray?.lastObject! as! UIViewController) .isKind(of: HomeViewController.self)){
                    
                    for views in self.navigationController?.viewControllers as NSArray!
                    {
                        if((views as! UIViewController) .isKind(of: HomeViewController.self))
                        {
                            fcheck=true
                            _ = navigationController?.popToViewController(views as! UIViewController, animated: false)
                            
                        }
                    }
                    if(fcheck==false){
                        
                        self.navigationController?.pushViewController(firstView, animated: true)
                    }
                }
                else{
                    
                    //reset button
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetMenuButton"), object: nil)
                }
            }
            else{
                
                appDelegate.navigationController?.pushViewController(firstView, animated: true)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetMenuButton"), object: nil)
            }
        }else if (indexPath.row == 1) {
            
            hideMenu()
            let firstView:EditProfielViewController
                = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "account") as! EditProfielViewController
            //            let firstView:HomeViewController = HomeViewController(nibName:"HomeViewController",bundle:Bundle.main)
            var fcheck=Bool()
            fcheck=false
            let viewArray=self.navigationController?.viewControllers as NSArray!
            if((viewArray) != nil){
                if !((viewArray?.lastObject! as! UIViewController) .isKind(of: EditProfielViewController.self)){
                    
                    for views in self.navigationController?.viewControllers as NSArray!
                    {
                        if((views as! UIViewController) .isKind(of: EditProfielViewController.self))
                        {
                            fcheck=true
                            _ = navigationController?.popToViewController(views as! UIViewController, animated: false)
                        }
                    }
                    if(fcheck==false){
                        
                        self.navigationController?.pushViewController(firstView, animated: true)
                    }
                }
                else{
                    
                    //reset button
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetMenuButton"), object: nil)
                }

            
            }
            
        }else if (indexPath.row == 2) {
            
            
            
        }else if (indexPath.row == 3){
            
            
            let firstView:InterestViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InterestViewController") as! InterestViewController
            var fcheck=Bool()
            fcheck=false
            let viewArray=self.navigationController?.viewControllers as NSArray!
            if((viewArray) != nil){
                if !((viewArray?.lastObject! as! UIViewController) .isKind(of: InterestViewController.self)){
                    
                    for views in self.navigationController?.viewControllers as NSArray!
                    {
                        if((views as! UIViewController) .isKind(of: InterestViewController.self))
                        {
                            fcheck=true
                            _ = navigationController?.popToViewController(views as! UIViewController, animated: false)
                            
                        }
                    }
                    if(fcheck==false){
                        
                        self.navigationController?.pushViewController(firstView, animated: true)
                    }
                }
                else{
                    
                    //reset button
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetMenuButton"), object: nil)
                }
            }
            else{
                
                //reset button
                appDelegate.navigationController?.pushViewController(firstView, animated: true)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetMenuButton"), object: nil)
            }
            

            
            
        }else if indexPath.row == 4 {
            
            hideMenu()
            let firstView:ExploreViewController
                = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "explore") as! ExploreViewController
            //            let firstView:HomeViewController = HomeViewController(nibName:"HomeViewController",bundle:Bundle.main)
            var fcheck=Bool()
            fcheck=false
            let viewArray=self.navigationController?.viewControllers as NSArray!
            if((viewArray) != nil){
                if !((viewArray?.lastObject! as! UIViewController) .isKind(of: ExploreViewController.self)){
                    
                    for views in self.navigationController?.viewControllers as NSArray!
                    {
                        if((views as! UIViewController) .isKind(of: ExploreViewController.self))
                        {
                            fcheck=true
                            _ = navigationController?.popToViewController(views as! UIViewController, animated: false)
                            
                        }
                    }
                    if(fcheck==false){
                        
                        self.navigationController?.pushViewController(firstView, animated: true)
                    }
                }
                else{
                    
                    //reset button
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetMenuButton"), object: nil)
                }
            }
            
        }else if indexPath.row == 5 {
            
            
            hideMenu()
            let firstView:FriendListViewController
                = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "friendList") as! FriendListViewController
            //            let firstView:HomeViewController = HomeViewController(nibName:"HomeViewController",bundle:Bundle.main)
            var fcheck=Bool()
            fcheck=false
            let viewArray=self.navigationController?.viewControllers as NSArray!
            if((viewArray) != nil){
                if !((viewArray?.lastObject! as! UIViewController) .isKind(of: FriendListViewController.self)){
                    
                    for views in self.navigationController?.viewControllers as NSArray!
                    {
                        if((views as! UIViewController) .isKind(of: FriendListViewController.self))
                        {
                            fcheck=true
                            _ = navigationController?.popToViewController(views as! UIViewController, animated: false)
                            
                        }
                    }
                    if(fcheck==false){
                        
                        self.navigationController?.pushViewController(firstView, animated: true)
                    }
                }
                else{
                    
                    //reset button
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetMenuButton"), object: nil)
                }
            }
            else{
                
                //reset button
                appDelegate.navigationController?.pushViewController(firstView, animated: true)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetMenuButton"), object: nil)
            }
            
        }else if indexPath.row == 8 {
            
            hideMenu()
            let firstView:WhoseAroundViewController
                = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "whoseAround") as! WhoseAroundViewController
            //            let firstView:HomeViewController = HomeViewController(nibName:"HomeViewController",bundle:Bundle.main)
            var fcheck=Bool()
            fcheck=false
            let viewArray=self.navigationController?.viewControllers as NSArray!
            if((viewArray) != nil){
                if !((viewArray?.lastObject! as! UIViewController) .isKind(of: WhoseAroundViewController.self)){
                    
                    for views in self.navigationController?.viewControllers as NSArray!
                    {
                        if((views as! UIViewController) .isKind(of: WhoseAroundViewController.self))
                        {
                            fcheck=true
                            _ = navigationController?.popToViewController(views as! UIViewController, animated: false)
                        }
                    }
                    if(fcheck==false){
                        
                        self.navigationController?.pushViewController(firstView, animated: true)
                    }
                }
                else{
                    
                    //reset button
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetMenuButton"), object: nil)
                }
                
                
            }

            
        }else if indexPath.row == 10 {
            hideMenu()
            let firstView:AboutUsViewController
                = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "aboutUs") as! AboutUsViewController
            //            let firstView:HomeViewController = HomeViewController(nibName:"HomeViewController",bundle:Bundle.main)
            var fcheck=Bool()
            fcheck=false
            let viewArray=self.navigationController?.viewControllers as NSArray!
            if((viewArray) != nil){
                if !((viewArray?.lastObject! as! UIViewController) .isKind(of: AboutUsViewController.self)){
                    
                    for views in self.navigationController?.viewControllers as NSArray!
                    {
                        if((views as! UIViewController) .isKind(of: AboutUsViewController.self))
                        {
                            fcheck=true
                            _ = navigationController?.popToViewController(views as! UIViewController, animated: false)
                            
                        }
                    }
                    if(fcheck==false){
                        
                        self.navigationController?.pushViewController(firstView, animated: true)
                    }
                }
                else{
                    
                    //reset button
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetMenuButton"), object: nil)
                }
            }
            else{
                
                //reset button
                appDelegate.navigationController?.pushViewController(firstView, animated: true)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetMenuButton"), object: nil)
            }
        }
    }
    
    // Override to support rearranging the table view.

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    // MARK: Custom Method
    func showMenu(){
        
        self.view.isHidden=false
        self.view.frame=CGRect(x:0.0,y:70,width:0.0,height:self.view.frame.height)
        //self.view.backgroundColor=UIColor.blackColor()
        UIView.animate(withDuration: 0.3, animations: {
           
            self.view.frame=CGRect(x:0.0,y:70,width:200.0,height:self.view.frame.size.height)
        })
    }
    func hideMenu(){

        let initialFrame=CGRect(x:-200.0,y:self.view.frame.origin.y,width:200,height:self.view.frame.size.height)
        UIView.animate(withDuration: 0.3, animations:{
            self.view.frame=initialFrame
        })
    }
    
    
    func downloadImage(string: String) {
        let uRL = URL(string: "\(string)")
        self.imageIcon.kf.setImage(with: uRL , placeholder: UIImage(named: "aboutUs"))
    }
    

}
