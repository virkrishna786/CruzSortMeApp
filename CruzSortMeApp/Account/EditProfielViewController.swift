//
//  EditProfielViewController.swift
//  CruzSortMeApp
//
//  Created by Admin media on 1/23/17.
//  Copyright © 2017 Gopal Gupta. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class EditProfielViewController: UIViewController {
    var boolValue = 0

    @IBAction func submitButtonAction(_ sender: UIButton) {
    }
    @IBAction func menuButtnAction(_ sender: UIButton) {
        
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
    @IBOutlet weak var profileImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addChildViewController(appDelegate.menuTableViewController)
        self.apiCall()

        // Do any additional setup after loading the view.
    }

    
    
    func apiCall(){
        
        if currentReachabilityStatus != .notReachable {
            
            hudClass.showInView(view: self.view)
            let  urlString = "http://182.73.133.220/CruzSortMe/Apis/testUpload"
            
            let image = UIImage(named: "icon.png")
            print("imagefh \(image)")
            let   imagedata  = UIImagePNGRepresentation(image!)
            print("imageDatadd \(imagedata!)")
            hudClass.showInView(view: self.view)
            
            let strBasefd = imagedata?.base64EncodedString(options: .lineLength64Characters)

//            
//            let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
//            let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
//            let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
//            if let dirPath          = paths.first
//            {
//                let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent("icon.png")
//                let image    = UIImage(contentsOfFile: imageURL.path)
//
            
            let  parameter = ["profile_pic" : strBasefd!]
            
            print("dfd \(parameter)")
            
            Alamofire.request(urlString, method: .post, parameters: parameter)
                .responseJSON { response in
                    print("Success: \(response.result.isSuccess)")
                    print("Response String: \(response.result.value)")
                    
                    //to get JSON return value
                    if let result = response.result.value {
                        let JSON = result as! NSDictionary
                        
                        let responseCode = JSON["CruzSortMe_app"] as! NSDictionary
                        
                        print("response code \(responseCode)")
                        
                        let responseMessage = responseCode["res_msg"] as! String
                        print("response message \(responseMessage)")
                        
                        if responseMessage == "Login has been Successfully" {
                            hudClass.hide()
                            
                            let userIdString = responseCode["user_id"] as! String
                            let userNameSavedString = responseCode["username"] as! String
                            let userProfileImageString = responseCode["profile_image"] as! String
                            defaults.set(userIdString, forKey: "userId")
                            defaults.set(userNameSavedString, forKey: "user_name")
                            defaults.set(userProfileImageString, forKey: "profile_image")
                            defaults.synchronize()
                            self.performSegue(withIdentifier: "homeView", sender: self)
                            
                        }else {
                            hudClass.hide()
                            
                            let alertVC = UIAlertController(title: "Alert", message: "Please enter valid email and password", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK",style:.default,handler: nil)
                            alertVC.addAction(okAction)
                            self.present(alertVC, animated: true, completion: nil)
                            
                        }
                        print("json \(JSON)")
                        
                    }
            }
            
            
        }else {
            parentClass.showAlert()
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
