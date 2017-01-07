//
//  ViewController.swift
//  CruzSortMeApp
//
//  Created by Admin media on 12/29/16.
//  Copyright © 2016 Gopal Gupta. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
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
    
    @IBAction func signUpButtonAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "signUp", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.apiCall()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func apiCall(){
        let urlString = "http://182.73.133.220/CruzSortMe/Apis/login"
        let userString = "\(usernameTextField.text!)"
        let passwordString = "\(passwordTextField.text!)"
        
       let  parameter = ["username" : userString
            , "password" : passwordString]
        
        print("dfd \(parameter)")
        
        Alamofire.request(urlString, method: .post, parameters: parameter)
            .responseJSON { response in
                print("Success: \(response.result.isSuccess)")
                print("Response String: \(response.result.value)")
        }

//                //to get JSON return value
//                if let result = response.result.value {
//                    let JSON = result as! NSDictionary
//                    print("json \(JSON)")
//                }
//        }
        
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

