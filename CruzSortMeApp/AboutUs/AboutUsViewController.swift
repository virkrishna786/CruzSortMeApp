//
//  AboutUsViewController.swift
//  CruzSortMeApp
//
//  Created by Admin media on 1/21/17.
//  Copyright © 2017 Gopal Gupta. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AboutUsViewController: UIViewController  {
    
    @IBOutlet weak var myTextView: UITextView!
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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addChildViewController(appDelegate.menuTableViewController)
        self.apiCall()

        // Do any additional setup after loading the view.
    }
    
    func apiCall(){
        
        if currentReachabilityStatus != .notReachable {
            
            hudClass.showInView(view: self.view)
            let  urlString = "\(baseUrl)aboutUs"
            
            Alamofire.request(urlString, method: .post)
                .responseJSON { response in
                    hudClass.hide()
                    print("Success: \(response.result.isSuccess)")
                    print("Response String: \(response.result.value)")
                    
                    //to get JSON return value
                    if let result = response.result.value {
                        let JSON = result as! NSDictionary
                        
                        let responseCode = JSON["About"] as! NSDictionary
                        print("response code \(responseCode)")
                            let uaboutIdString = responseCode["id"] as! String
                        print("abouasas\(uaboutIdString)")
                        
                            let textDataString = responseCode["text_data"] as! String
                         self.myTextView.text = textDataString
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
