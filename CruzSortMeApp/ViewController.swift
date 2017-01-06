//
//  ViewController.swift
//  CruzSortMeApp
//
//  Created by Admin media on 12/29/16.
//  Copyright © 2016 Gopal Gupta. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var loginButton: UIButton!
    {
        didSet{
            
            loginButton.layer.cornerRadius = 30
        }
    }
    @IBOutlet weak var googleSignInButton: UIButton!
    @IBAction func forgetPasswordButtonAction(_ sender: UIButton) {
       self.performSegue(withIdentifier: "forgetPassword", sender: self)
    }
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func apiCall(){
        
    let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        Alamofire.request("", method: .post, parameters: ["username": "krishna" , "password": "12345"], encoding: JSONEncoding.default , headers: headers)
            .responseJSON { response in
                print(response.request as Any)  // original URL request
                print(response.response as Any) // URL response
                print(response.result.value as Any)   // result of response serialization
        }
    }
    
    
    @IBAction func loginButtonAction(_ sender: UIButton) {

        DispatchQueue.global(qos: .background).async {
            self.apiCall()
        }
    }
    @IBAction func facebookButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func twitterButtonAction(_ sender: UIButton) {
    }

    @IBAction func googleSignInButtonAction(_ sender: UIButton) {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

