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
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
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
                
                //to get JSON return value
                if let result = response.result.value {
                                    let JSON = result as! NSDictionary
                                    print("json \(JSON)")
            }
        }


        
    }
    
    // MARK:- Keyboard notification
    
//    func registerForKeyboardNotifications(){
//        //Adding notifies on keyboard appearing
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//    }
//    
//    func deregisterFromKeyboardNotifications(){
//        //Removing notifies on keyboard appearing
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//    }
//    
//    
//    
//    func keyboardWasShown(notification: NSNotification){
//        //Need to calculate keyboard exact size due to Apple suggestions
//        self.myScrollView.isScrollEnabled = true
//        var info = notification.userInfo!
//        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
//        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
//        
//        self.myScrollView.contentInset = contentInsets
//        self.myScrollView.scrollIndicatorInsets = contentInsets
//        
//        var aRect : CGRect = self.view.frame
//        aRect.size.height -= keyboardSize!.height
//        if let activeField = self.activeField {
//            if (!aRect.contains(activeField.)){
//                self.myScrollView.scrollRectToVisible(activeField.frame, animated: true)
//            }
//        }
//    }
//    
//    func keyboardWillBeHidden(notification: NSNotification){
//        //Once keyboard disappears, restore original positions
//        var info = notification.userInfo!
//        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
//        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
//        self.myScrollView.contentInset = contentInsets
//        self.myScrollView.scrollIndicatorInsets = contentInsets
//        self.view.endEditing(true)
//        self.myScrollView.isScrollEnabled = false
//    }
//    
//    func textFieldDidBeginEditing(_ textField: UITextField){
//        activeField = textField
//    }
//    
//    func textFieldDidEndEditing(_ textField: UITextField){
//        activeField = nil
//    }
//    
    
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

