//
//  SignUpViewController.swift
//  CruzSortMeApp
//
//  Created by Admin media on 1/6/17.
//  Copyright © 2017 Gopal Gupta. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SignUpViewController: UIViewController ,UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    @IBOutlet weak var myScroolView: UIScrollView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBAction func datePickerAction(_ sender: UIDatePicker) {
        self.setDateAndTime()
    }
    
    //    override func viewDidLayoutSubviews() {
    //        profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2
    //        profileImageView.clipsToBounds = true
    //        self.viewDidLayoutSubviews()
    //
    //    }
    @IBOutlet weak var CnfirmPasswordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func femaleButtonAction(_ sender: UIButton) {
        
        if (femaleButton.currentImage?.isEqual(UIImage(named: "genderIcon")))! {
            let image = UIImage(named: "genderColorIcon")
            femaleButton.setImage(image, for: UIControlState.normal)
            maleButton.setImage(UIImage(named : "genderIcon"), for: UIControlState.normal)

        }else {
            let imageIcon = UIImage(named: "genderIcon")
            femaleButton.setImage(imageIcon, for: UIControlState.normal)
            maleButton.setImage(UIImage(named : "genderColorIcon"), for: UIControlState.normal)

        }
        
    }
    @IBOutlet weak var femaleButton: UIButton!
    @IBAction func maleButtonAction(_ sender: UIButton) {
        
        if (maleButton.currentImage?.isEqual(UIImage(named: "genderIcon")))! {
            let image = UIImage(named: "genderColorIcon")
            maleButton.setImage(image, for: UIControlState.normal)
            femaleButton.setImage(UIImage(named : "genderIcon"), for: UIControlState.normal)

        }else {
            let imageIcon = UIImage(named: "genderIcon")
            maleButton.setImage(imageIcon, for: UIControlState.normal)
            femaleButton.setImage(UIImage(named : "genderColorIcon"), for: UIControlState.normal)

        }
        
    }
    @IBOutlet weak var maleButton: UIButton!
    @IBAction func dobButtonAction(_ sender: UIButton) {
        self.datePicker.isHidden = false
    }
    @IBOutlet weak var dobButton: UIButton!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
        
    }
    @IBOutlet weak var signUpButton: UIButton!
        {
        didSet{
            
            signUpButton.layer.cornerRadius = 30
        }
    }
    @IBAction func signUpButtonAction(_ sender: UIButton) {
        
        if nameTextField.text == "" && usernameTextField.text == "" && phoneNumberTextField.text == "" && passwordTextField.text == "" && CnfirmPasswordTextField.text == "" {
            
            
            let alertVC = UIAlertController(title: "Alert", message: "Please enter the details", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK",style:.default,handler: nil)
            alertVC.addAction(okAction)
            present(alertVC,animated: true,completion: nil)
            
        } else if passwordTextField.text != CnfirmPasswordTextField.text  {
            
            let alertVC = UIAlertController(title: "Alert", message: "Please enter same password", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK",style:.default,handler: nil)
            alertVC.addAction(okAction)
            present(alertVC,animated: true,completion: nil)
            
        } else if maleButton.titleLabel?.text != "male" || femaleButton.titleLabel?.text != "female" {
            
            let alertVC = UIAlertController(title: "Alert", message: "Please select your gender", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK",style:.default,handler: nil)
            alertVC.addAction(okAction)
            present(alertVC,animated: true,completion: nil)
            
        } else {
                self.signUpApi()
        }
    }
    @IBAction func camaraButtonAction(_ sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.allowsEditing = false
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.cameraCaptureMode = .photo
            imagePicker.modalPresentationStyle = .fullScreen
            present(imagePicker,animated: true,completion: nil)
        } else if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
            
        }else {
            
            self.noCamara()
        }
    }
    @IBOutlet weak var camaraButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
        {
        didSet {
            
            profileImageView.layer.borderWidth = 1
            profileImageView.layer.masksToBounds = false
            profileImageView.layer.borderColor = UIColor.white.cgColor
            profileImageView.layer.cornerRadius = profileImageView.frame.height/2
            profileImageView.clipsToBounds = true
        }
    }
    
    let imagePicker = UIImagePickerController()
    let dateFormatter = DateFormatter()
    var dateString : String!
    var groupImage : UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        self.datePicker.isHidden = true
        datePicker.backgroundColor = .red
        self.navigationController?.navigationBar.isHidden = true
        
        myScroolView.contentSize = CGSize(width: self.view.frame.size.width, height: 1500)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        
        myScroolView.addGestureRecognizer(tap)
        
        
        // Do any additional setup after loading the view.
    }
    
    
    func dismissKeyboard() {
        nameTextField.resignFirstResponder()
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        CnfirmPasswordTextField.resignFirstResponder()
        phoneNumberTextField.resignFirstResponder()
        self.datePicker.isHidden = true
        self.view.endEditing(true)
        
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage  {
            profileImageView.contentMode = .scaleAspectFit
            profileImageView.image = pickedImage
            DispatchQueue.global().async(execute: {
                self.setImage(image: pickedImage)
            })

        }
        dismiss(animated: true, completion: nil)
    }
    func  setImage(image: UIImage!)  {
        self.groupImage = image
        print("jkek \(self.groupImage!)")
    }

    
    
    func noCamara(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
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
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // api for SignUp
    
    func signUpApi() {
        
         if currentReachabilityStatus != .notReachable {
        
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        let name = nameTextField.text!
        let username = usernameTextField.text!
        let phoneNumber  = phoneNumberTextField.text!
        let age = dobButton.titleLabel?.text!
        let password = passwordTextField.text!
        let conformPassword = CnfirmPasswordTextField.text!
        let gender : String!
        if maleButton.isSelected == true {
            gender = "male"
        } else  {
            gender = "female"
        }
        
        let parameter = ["name": name,
                         "email": username,
                         "phone": phoneNumber,
                         "age" :  age,
                         "gender" : gender,
                         "password": password,
                         "cpassword" : conformPassword,
                         ]
        
        
        //  let URL = "http://182.73.133.220/CruzSortMe/Apis/signUp"
        let image = UIImage(named: "\(self.groupImage)")
            let   imagedata  = UIImageJPEGRepresentation(image!, 0.2)
            hudClass.showInView(view: self.view)
        
        let URL = try! URLRequest(url: "\(baseUrl)signUp", method: .post, headers: headers)
            
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imagedata!, withName: "profile_pic", fileName: "krish.jpg", mimeType: "image/png")
            
            for (key, value) in parameter {
                multipartFormData.append((value?.data(using: String.Encoding.utf8)!)!, withName: key)
            }        }, with: URL, encodingCompletion: { (encodingResult) in
                
                switch encodingResult {
                case .success(let upload, _, _):
                    print("s")
                    upload.responseString {
                        response in
                        print(response.request! )  // original URL request
                        print(response.response! ) // URL response
                        print(response.data! )     // server data
                        print(response.result)   // result of response serialization
                        
                        hudClass.hide()
                        
                          switch response.result  {
                                
                                case .success(let datads) :
                                print("dasdfkas \(datads)")
                                let dsfs = datads.data(using: String.Encoding.utf8)!
                                let json = JSON(data: dsfs)
                                //     let responseCode = json["CruzSortMe_app"].dictionary
                                //     print("response code \(responseCode)")
                                
                                let resData = json["CruzSortMe_app"].dictionary
                                
                                print("resData \(resData)")
                                
                                let responseMessage = resData?["res_msg"]!.string
                                print("response message \(responseMessage)")
                                
                                if responseMessage == "signup Successfully" {
                                    hudClass.hide()
                                    print("save successFully")
                            let userIdString = resData?["user_id"]!.string
                                    
                                        defaults.set(userIdString, forKey: "userId")
                                            self.performSegue(withIdentifier: "homeView", sender: self)

                                    
                                }else {
                                    hudClass.hide()
                        
                                    let alertVC = UIAlertController(title: "Alert", message: "Please enter valid email and password", preferredStyle: .alert)
                                    let okAction = UIAlertAction(title: "OK",style:.default,handler: nil)
                                    alertVC.addAction(okAction)
                                self.present(alertVC, animated: true, completion: nil)

                                }
                                
                                
                                case .failure(let errordarta) :
                                hudClass.hide()
                                print("err0rdata \(errordarta)")
                                
                        }
//                        if let result = response.result.value {
//                            
//                            let JSON = result as! NSDictionary
//                            
//                            let responseCode = JSON["CruzSortMe_app"] as! NSDictionary
//                            
//                            print("response code \(responseCode)")
//                            
//                            let responseMessage = responseCode["res_msg"] as! String
//                            print("response message \(responseMessage)")
//                            
//                            if responseMessage == "signup Successfully" {
//                                
//                                let userIdString = responseCode["user_id"] as! String
//                                defaults.set(userIdString, forKey: "userId")
//                                
//                                self.performSegue(withIdentifier: "homeView", sender: self)
//                                
//                            }else {
//                                
//                                let alertVC = UIAlertController(title: "Alert", message: "Please enter valid email and password", preferredStyle: .alert)
//                                let okAction = UIAlertAction(title: "OK",style:.default,handler: nil)
//                                alertVC.addAction(okAction)
//                                self.present(alertVC, animated: true, completion: nil)
//                                
//                            }
//                            
//                            
//                            print("JSON: \(result)")
//                            if let JSON = response.result.value {
//                                print("JSON: \(JSON)")
//                            }
//                        }
                    }
                case .failure(let encodingError):
                    hudClass.hide()
                    parentClass.showAlert()
                    print(encodingError)
                }
        })
            
         }else {
            parentClass.showAlert()
        }
        
    }
    
    // MARK -: set date of birth
    func setDateAndTime() {
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.dateFormat = "dd/MM/YYYY"
        dobButton.titleLabel?.text = dateFormatter.string(from: datePicker.date)
    }
    
    
    //MARK: - HANDLE KEYBOARD
    func handleKeyBoardWillShow(notification: NSNotification) {
        
        let dictionary = notification.userInfo
        let value = dictionary?[UIKeyboardFrameBeginUserInfoKey]
        let keyboardSize = (value as AnyObject).cgRectValue.size
        
        let inset = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.height) + 30, 0.0)
        myScroolView.contentInset = inset
        myScroolView.scrollIndicatorInsets = inset
        
    }
    
    //MARK: HANDLE KEYBOARD
    func handleKeyBoardWillHide(sender: NSNotification) {
        
        let inset1 = UIEdgeInsets.zero
        myScroolView.contentInset = inset1
        myScroolView.scrollIndicatorInsets = inset1
        myScroolView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //  myScrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        self.view.endEditing(true)
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField.isEqual(passwordTextField ) || textField.isEqual(CnfirmPasswordTextField) {
            myScroolView.setContentOffset(CGPoint(x: 0, y: 400), animated: true)
            
        } else {
            myScroolView.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
        }
    }
    
        func textFieldDidEndEditing(_ textField: UITextField) {
            myScroolView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
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
