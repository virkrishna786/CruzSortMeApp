//
//  MenuTVC.swift
//  MyRentApp
//
//  Created by Saurabh  on 7/6/15.
//  Copyright (c) 2015 Dogma Systems. All rights reserved.
//

import UIKit

class MenuTVC: UITableViewController {
 
    let LeftMenuWidth = 100.0
    var headerView:UIView?
    var SA_Choice=["Home","Movements","Vehicle","Customer","Reservation","Deposite List","Contact Us","Privacy Policy","Copyright(c)","Log Out",""]
    var SA_Icons=["homeIcon.png","movementsIcon.png","movementsIcon.png","vehicle-class.png","customerIcon.png","customerIcon.png","contactusIcon.png","privacyIcon.png","copyrightIcon.png","logoutIcon.png",""]
    override func viewDidLoad() {
        
        self.view .backgroundColor=UIColor.black.withAlphaComponent(0.8)
        //MenuTVC .frame.size.height=800
        tableView.isScrollEnabled=true
        headerView=UIView()
        setTableviewHeader()
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setTableviewHeader(){
        
        //let headerView=UIView()
        headerView!.frame=CGRect(x: 0, y: 0, width: 150, height: 150)//CGRect(0, 0, 220, 200)
        let imageIcon=UIImageView()
        imageIcon.frame=CGRect(x: 53, y: 9, width: 100, height: 100)//CGRect(53,9,150,145)
        imageIcon.image=UIImage(named:"logoRoll.png")
        let imageLabel=UIImageView()
        imageLabel.image=UIImage(named:"myrent.png")
        imageLabel.frame=CGRect(x: 60, y: 150, width:85, height:30)//CGRectMake(60,150, 85, 30)
        headerView!.backgroundColor=UIColor.white.withAlphaComponent(0.5)
        headerView!.addSubview(imageIcon)
        //headerView.addSubview(imageLabel)
        headerView!.clipsToBounds=true
        self.tableView.tableHeaderView=headerView
        
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
      return 1
    }
    

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 70
    }
    func numberOfRows(inSection section: Int) -> Int{
        
        return SA_Choice.count
    }
   
    func cellForRow(at indexPath: IndexPath) -> UITableViewCell?{
        
    
        
        let cell=UITableViewCell()
        // Configure the cell...
        tableView.separatorStyle=UITableViewCellSeparatorStyle.none
        cell.backgroundColor=UIColor.clear
        cell.textLabel?.textColor=UIColor.white
        cell.textLabel?.font=UIFont (name: "Avenir-Medium", size: 20)
        cell.textLabel!.text=SA_Choice[indexPath.row] as String
        //icons
        cell.imageView?.image=UIImage(named:(SA_Icons[indexPath.row] as String))
        return cell
    }
    func selectRow(at indexPath: IndexPath?, animated: Bool, scrollPosition: UITableViewScrollPosition){
   
        
        //print(self.navigationController?.viewControllers)
        
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
           
            self.view.frame=CGRect(x:0.0,y:70,width:180.0,height:self.view.frame.size.height)
        })
    }
    func hideMenu(){

        let initialFrame=CGRect(x:-280.0,y:self.view.frame.origin.y,width:280,height:self.view.frame.size.height)
        UIView.animate(withDuration: 0.3, animations:{
            self.view.frame=initialFrame
        })
    }
}
