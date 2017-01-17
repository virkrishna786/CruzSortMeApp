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

class ViewController: UIViewController ,UITextFieldDelegate {

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
    var activeField = UITextField?.self
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.gestureFunction))
        myScrollView.addGestureRecognizer(tapGesture)
       
        let useriDstring = defaults.string(forKey: "userId")
        
        if useriDstring == "" {
            
        }else {
            self.performSegue(withIdentifier: "homeView", sender: self)
        }
        print("userid \(useriDstring!)")
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func gestureFunction(){
        myScrollView.endEditing(true)
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
                
                //to get JSON return value
                if let result = response.result.value {
                                    let JSON = result as! NSDictionary
                    
                    let responseCode = JSON["CruzSortMe_app"] as! NSDictionary
                    
                    print("response code \(responseCode)")
                    
                    let responseMessage = responseCode["res_msg"] as! String
                    print("response message \(responseMessage)")
                    
                    if responseMessage == "Login has been Successfully" {
                        
                        let userIdString = responseCode["user_id"] as! String
                        
                        defaults.set(userIdString, forKey: "userId")
                        defaults.synchronize()
                        self.performSegue(withIdentifier: "homeView", sender: self)
   
                    }else {
                        
                        let alertVC = UIAlertController(title: "Alert", message: "Please enter valid email and password", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK",style:.default,handler: nil)
                        alertVC.addAction(okAction)
                        self.present(alertVC, animated: true, completion: nil)
  
                    }
                                    print("json \(JSON)")
                    
                              }
        }

    }

    //MARK: - HANDLE KEYBOARD
    func handleKeyBoardWillShow(notification: NSNotification) {
        
        let dictionary = notification.userInfo
        let value = dictionary?[UIKeyboardFrameBeginUserInfoKey]
        let keyboardSize = (value as AnyObject).cgRectValue.size
        
        let inset = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.height) + 30, 0.0)
         myScrollView.contentInset = inset
        myScrollView.scrollIndicatorInsets = inset
        
    }
    
    //MARK: HANDLE KEYBOARD
    func handleKeyBoardWillHide(sender: NSNotification) {
        
        let inset1 = UIEdgeInsets.zero
        myScrollView.contentInset = inset1
        myScrollView.scrollIndicatorInsets = inset1
        myScrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
      //  myScrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        self.view.endEditing(true)
        
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        myScrollView.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        myScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
  
    
       
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
//        let controller = storyboard?.instantiateViewController(withIdentifier: "homeView")
//        self.navigationController?.pushViewController(controller!, animated: true)
        
        if usernameTextField.text == "" || passwordTextField.text == "" {
            
            let alertVC = UIAlertController(title: "Alert", message: "Please enter  email and password", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK",style:.default,handler: nil)
            alertVC.addAction(okAction)
            self.present(alertVC, animated: true, completion: nil)

        }else{
        DispatchQueue.global(qos: .background).async {
             self.apiCall()
        }
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

