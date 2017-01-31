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
    
    
    @IBAction func dobButtonAction(_ sender: UIButton) {
        self.datePicker.isHidden = false

    }
    var gender : String!
    
    let dateFormatter = DateFormatter()
    var dateString : String!

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBAction func datePickerAction(_ sender: UIDatePicker) {
        self.setDateAndTime()
    }
    
    var groupImage : UIImage!
    var userIdString : String!
    @IBOutlet weak var myScroolView: UIScrollView!
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
    @IBOutlet weak var maleButton: UIButton!
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
    @IBOutlet weak var scheduleUpcomingTextField: UITextField!
    @IBOutlet weak var dateOfBrithTextField: UITextField!
    @IBOutlet weak var resortTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBAction func submitButtonAction(_ sender: UIButton) {
        self.updateUserInfoApiHit()
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
        
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//            imagePicker.allowsEditing = false
//            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
//            imagePicker.cameraCaptureMode = .photo
//            imagePicker.modalPresentationStyle = .fullScreen
//            present(imagePicker,animated: true,completion: nil)
//        } else
//            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
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
     var editProfileArray = [EditProfileClass]()

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        self.datePicker.isHidden = true
        self.datePicker.backgroundColor = UIColor.red
        self.dateOfBrithTextField.delegate = self
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

        // Do any additional setup after loading the view.
    }
    
    // MARK -: set date of birth
    func setDateAndTime() {
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.dateFormat = "dd/MM/YYYY"
        dateOfBrithTextField.text = dateFormatter.string(from: datePicker.date)
    }
    
    
    func dismissKeyboard() {
        nameTextField.resignFirstResponder()
        nameTextField.resignFirstResponder()
        resortTextField.resignFirstResponder()
        dateOfBrithTextField.resignFirstResponder()
        scheduleUpcomingTextField.resignFirstResponder()
        self.datePicker.isHidden = true 
        self.view.endEditing(true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage  {
            profileImageView.contentMode = .scaleAspectFit
          //  profileImageView.image = pickedImage
            DispatchQueue.global().async(execute: {
               self.uploadImageApi(image: pickedImage)
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

    func  uploadImageApi(image : UIImage) {
        if currentReachabilityStatus != .notReachable {
            
//            let images   = UIImage(named : "\(self.groupImage!)")
//            print("images \(images)")
            let   imagedata  = UIImageJPEGRepresentation(image, 0.2)
            print("imageDatadd \(imagedata!)")
            hudClass.showInView(view: self.view)
            
            let URL = try! URLRequest(url: "\(baseUrl)userProfileImgDetail", method: .post)
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
                                
                                if responseMessage == "Image Update Successfully" {
                                    hudClass.hide()
                                    print("save successFully")
                                    
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
            let  urlString = "\(baseUrl)accountDetail"
            let  parameter = ["user_id" : "\(self.userIdString!)"
                ]
            
            print("dfd \(parameter)")
            
            Alamofire.request(urlString, method: .post, parameters: parameter)
                .responseJSON { response in
                    print("Success: \(response.result.isSuccess)")
                    print("Response String: \(response.result.value)")
                    
                    switch response.result {
                        
                    case .success(let resposneData) :
                        print("dffgsdf \(resposneData)")

                        let json = JSON(resposneData)
                        
                        let responseMessage = (json["res_msg"].string)!
                        print("response message \(responseMessage)")
                        
                        if responseMessage == "Record  Found Successfully" {
                            hudClass.hide()
                            
                            let responseCode = (json["CruzSortMe"].array)!
                            print("response code \(responseCode)")
                            
                            
                            for responsArray in responseCode {
                             
                                let userNameSavedString = responsArray["name"].string
                                self.nameTextField.text = userNameSavedString!
                                let userProfileImageString = responsArray["profile_image"].string
                                let genderString = responsArray["gender"].string
                                let doBString = responsArray["dob"].string
                                
                                self.dateOfBrithTextField.text = doBString
                                
                                print("genderString \(genderString)")
                                
                                if genderString == "Male" {
                                    self.maleButton.setImage(UIImage(named: "genderColorIcon"), for: UIControlState.normal)
                                    self.femaleButton.setImage(UIImage(named: "genderIcon"), for: UIControlState.normal)
                                }else {
                                    self.femaleButton.setImage(UIImage(named: "genderColorIcon"), for: UIControlState.normal)
                                    self.maleButton.setImage(UIImage(named: "genderIcon"), for: UIControlState.normal)
                                }
                                
                                print("userProfileImageString \(userProfileImageString!)")
                                let url = URL(string: "\(userProfileImageString!)")
                                
                                DispatchQueue.main.async {
                                    self.profileImageView.kf.setImage(with: url , placeholder : UIImage(named: "aboutUs"))

                                }
                                //                            defaults.set(userNameSavedString, forKey: "user_name")
                                //                            defaults.set(userProfileImageString, forKey: "profile_image")
                                //                            defaults.synchronize()
                                
                            }
                            
                        }else {
                            
                            hudClass.hide()
                            self.dateOfBrithTextField.text = ""
                            self.nameTextField.text = ""
                            let alertVC = UIAlertController(title: "Alert", message: "Some thing went wrong", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK",style:.default,handler: nil)
                            alertVC.addAction(okAction)
                            self.present(alertVC, animated: true, completion: nil)

                        }
                    case .failure (let errorData) :
                        hudClass.hide()
                        self.dateOfBrithTextField.text = ""
                        self.nameTextField.text = ""
                        let alertVC = UIAlertController(title: "Alert", message: "Some thing went wrong", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK",style:.default,handler: nil)
                        alertVC.addAction(okAction)
                        self.present(alertVC, animated: true, completion: nil)
                        print("dfgdsffasesr\(errorData)")
                    
                    }
            }
            
            
        }else {
            parentClass.showAlert()
        }
        
        
    }
    
    
    // MARK:- update Account detail Api
    
    func updateUserInfoApiHit() {
        
        if currentReachabilityStatus != .notReachable {
            
            if maleButton.isSelected == true {
                gender = "male"
            } else  {
                gender = "female"
            }
            
            let url = "\(baseUrl)updateUserInfo"
            
            let parameter = ["user_id" : "\(self.userIdString!)",
                             "name" : "\(self.nameTextField.text!)",
                             "dob" : "\(dateOfBrithTextField.text!)",
                             "gender" : "\(gender!)",
                             "resortat" : "\(self.resortTextField.text!)",
                             "location_lat" : "28.536740",
                             "location_log" : "77.399377"

                ]
            print("parameter \(parameter)")
            hudClass.showInView(view: self.view)
            
            Alamofire.request( url, method : .post, parameters: parameter).responseJSON { (responseObject) -> Void in
                
                print(responseObject)
                
                print("rsposneIbekjds \(responseObject)")
                if responseObject.result.isSuccess {
                    hudClass.hide()
                    let resJson = JSON(responseObject.result.value!)
                    
                    print("resJsonf \(resJson)")
                    let  res_message  = (resJson["res_msg"].string)!
                    print("res_messafe \(res_message)")
                    
                    if res_message == "Update Successfully" {
                        
                        let alertVC = UIAlertController(title: "Alert", message: "Your Profile has been updated", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK",style:.default,handler: nil)
                        alertVC.addAction(okAction)
                        self.present(alertVC,animated: true,completion: nil)
                        
                    }else {
                        hudClass.hide()
                        parentClass.showAlertWithApiFailure()
                        print("sdkgdksbhgks")
                    }
                }
                if responseObject.result.isFailure {
                    hudClass.hide()
                    parentClass.showAlertWithApiFailure()
                    let error  = responseObject.result.error!  as NSError
                    print("\(error)")
                }
            }
            
        }else{
            hudClass.hide()
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
