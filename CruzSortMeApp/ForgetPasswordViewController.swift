//
//  ForgetPasswordViewController.swift
//  CruzSortMeApp
//
//  Created by Admin media on 1/5/17.
//  Copyright © 2017 Gopal Gupta. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ForgetPasswordViewController: UIViewController {

    @IBOutlet weak var resetButton: UIButton!
    {
        didSet {
            resetButton.layer.cornerRadius = 30
        }
    }
    @IBAction func resetLinkButtonAction(_ sender: UIButton) {
        
        if emailTextField.text == "" {
         
            let alertVC = UIAlertController(
                title: "Alert",
                message: "Please enter your email",
                preferredStyle: .alert)
            let okAction = UIAlertAction(
                title: "OK",
                style:.default,
                handler: nil)
            alertVC.addAction(okAction)
            present(
                alertVC,
                animated: true,
                completion: nil)
            
        }else {
        DispatchQueue.global(qos: .background).async {
            self.forgetApiCall()
        }
        }
    }
    @IBOutlet weak var emailTextField: UITextField!
    @IBAction func backButtonAction(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    func forgetApiCall() {
        
        let urlString = "http://182.73.133.220/CruzSortMe/Apis/forgotPassword"
        let userString = "\(emailTextField.text!)"
        
        let  parameter = ["username" : userString]
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
