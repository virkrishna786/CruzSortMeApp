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

class EditProfielViewController: UIViewController ,UITextFieldDelegate ,UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    var boolValue = 0
    
    
    var groupImage : UIImage!
    var userIdString : String!
    @IBOutlet weak var myScroolView: UIScrollView!
    @IBAction func femaleButtonAction(_ sender: UIButton) {
        
        if (femaleButton.currentImage?.isEqual(UIImage(named: "genderIcon")))! {
            let image = UIImage(named: "genderColorIcon")
            femaleButton.setImage(image, for: UIControlState.normal)
        }else {
            let imageIcon = UIImage(named: "genderIcon")
            femaleButton.setImage(imageIcon, for: UIControlState.normal)
        }
    }
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var maleButton: UIButton!
    @IBAction func maleButtonAction(_ sender: UIButton) {
        if (maleButton.currentImage?.isEqual(UIImage(named: "genderIcon")))! {
            let image = UIImage(named: "genderColorIcon")
            maleButton.setImage(image, for: UIControlState.normal)
        }else {
            let imageIcon = UIImage(named: "genderIcon")
            maleButton.setImage(imageIcon, for: UIControlState.normal)
        }

    }
    @IBOutlet weak var scheduleUpcomingTextField: UITextField!
    @IBOutlet weak var dateOfBrithTextField: UITextField!
    @IBOutlet weak var resortTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
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

    @IBOutlet weak var profileImageView: UIImageView!  {
        didSet {
            
            profileImageView.layer.borderWidth = 1
            profileImageView.layer.masksToBounds = false
            profileImageView.layer.borderColor = UIColor.white.cgColor
            profileImageView.layer.cornerRadius = profileImageView.frame.height/2
            profileImageView.clipsToBounds = true
        }
    }
    let imagePicker = UIImagePickerController()


    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        self.navigationController?.navigationBar.isHidden = true

        let useriDstring = defaults.string(forKey: "userId")
        self.userIdString = useriDstring!
        print("userid \(useriDstring!)")
        myScroolView.contentSize = CGSize(width: self.view.frame.size.width, height: 1500)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        
        myScroolView.addGestureRecognizer(tap)
        
        self.getUserDetailCall()
        

        self.addChildViewController(appDelegate.menuTableViewController)
       //  self.apiCall()

        // Do any additional setup after loading the view.
    }
    
    
    func dismissKeyboard() {
        nameTextField.resignFirstResponder()
        nameTextField.resignFirstResponder()
        resortTextField.resignFirstResponder()
        dateOfBrithTextField.resignFirstResponder()
        scheduleUpcomingTextField.resignFirstResponder()
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
        nameTextField.resignFirstResponder()
        resortTextField.resignFirstResponder()
        scheduleUpcomingTextField.resignFirstResponder()
        dateOfBrithTextField.resignFirstResponder()
        self.view.endEditing(true)
        
    }

    func  apiCall() {
        if currentReachabilityStatus != .notReachable {
            
            let image = UIImage(named: "\(self.groupImage)")
            print("imagefh \(image)")
            let   imagedata  = UIImageJPEGRepresentation(image!, 0.2)
            print("imageDatadd \(imagedata!)")
            hudClass.showInView(view: self.view)
            
            let URL = try! URLRequest(url: "\(baseUrl)updateUserProfile", method: .post)
            print("URLS : \(URL)")
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(imagedata!, withName: "profile_pic", fileName: "krish.jpg", mimeType: "image/png/jpeg/jpg")
              
            }, with: URL, encodingCompletion: { (encodingResult) in
                
                switch encodingResult {
                case .success(let upload, _, _):
                    print("successessret")
                    upload.responseString { response in
                        print("request dfd \(response.request!)")  // original URL request
                        print("response data \(response.data!)")     // server data
                        print("response.result value \(response.result.value)")   // result of response serialization
                        
                        switch  response.result {
                            
                        case .success(let datads) :
                            print("dasdfkas \(datads)")
                                let dsfs = datads.data(using: String.Encoding.utf8)!
                                let json = JSON(data: dsfs)
                           //     let responseCode = json["CruzSortMe_app"].dictionary
                           //     print("response code \(responseCode)")
                                
                                let responseMessage = (json["res_msg"].string)!
                                print("response message \(responseMessage)")
                                
                                if responseMessage == "save Successfully" {
                                    hudClass.hide()
                                    print("save successFully")
                                    
                                    _ = self.navigationController?.popViewController(animated: true)
                                    
                                }else {
                                    hudClass.hide()
                                    let alertVC = UIAlertController(title: "Alert", message: "some thing went wrong", preferredStyle: .alert)
                                    let okAction = UIAlertAction(title: "OK",style:.default,handler: nil)
                                    alertVC.addAction(okAction)
                                    self.present(alertVC, animated: true, completion: nil)
                                }
                                
                            
                        case .failure(let errordarta) :
                            hudClass.hide()
                            print("err0rdata \(errordarta)")
                            
                        }
                        
                                           }
                case .failure(let encodingError):
                    hudClass.hide()
                    parentClass.showAlertWithApiFailure()
                    print(encodingError)
                }
            })
        }else {
            hudClass.hide()
            parentClass.showAlert()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField.isEqual(scheduleUpcomingTextField ) {
            myScroolView.setContentOffset(CGPoint(x: 0, y: 200), animated: true)
            
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
    
    
    // MARK: - userDeatil APi
    
    func getUserDetailCall(){
        
        if currentReachabilityStatus != .notReachable {
            
            hudClass.showInView(view: self.view)
            let  urlString = "\(baseUrl)login"
            let  parameter = ["user_id" : "\(self.userIdString)"
                ]
            
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
