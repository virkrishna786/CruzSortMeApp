//
//  SignUpViewController.swift
//  CruzSortMeApp
//
//  Created by Admin media on 1/6/17.
//  Copyright © 2017 Gopal Gupta. All rights reserved.
//

import UIKit
import Alamofire

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
        }else {
            let imageIcon = UIImage(named: "genderIcon")
         femaleButton.setImage(imageIcon, for: UIControlState.normal)
        }
       
    }
    @IBOutlet weak var femaleButton: UIButton!
    @IBAction func maleButtonAction(_ sender: UIButton) {
        
        if (maleButton.currentImage?.isEqual(UIImage(named: "genderIcon")))! {
            let image = UIImage(named: "genderColorIcon")
            maleButton.setImage(image, for: UIControlState.normal)
        }else {
            let imageIcon = UIImage(named: "genderIcon")
            maleButton.setImage(imageIcon, for: UIControlState.normal)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        self.datePicker.isHidden = true
        datePicker.backgroundColor = .red
        
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
        }
        dismiss(animated: true, completion: nil)
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
        let image = UIImage(named: "krish.png")
        let   imagedata  = UIImagePNGRepresentation(image!)
        
        let URL = try! URLRequest(url: "http://182.73.133.220/CruzSortMe/Apis/signUp", method: .post, headers: headers)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imagedata!, withName: "profile_pic", fileName: "krish.png", mimeType: "image/png")
            
            
            for (key, value) in parameter {
                multipartFormData.append((value?.data(using: String.Encoding.utf8)!)!, withName: key)
            }        }, with: URL, encodingCompletion: { (encodingResult) in
                
                switch encodingResult {
                case .success(let upload, _, _):
                    print("s")
                    upload.responseJSON {
                        response in
                        print(response.request! )  // original URL request
                        print(response.response! ) // URL response
                        print(response.data! )     // server data
                        print(response.result)   // result of response serialization
                        
                        if let JSON = response.result.value {
                            print("JSON: \(JSON)")
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
        })
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
//        if textField == nameTextField || textField == usernameTextField {
//            myScroolView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
//        }else {
        myScroolView.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
//        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        myScroolView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }


//    var dateFormatter = NSDateFormatter()
//    dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
//    var strDate = dateFormatter.stringFromDate(myDatePicker.date)
//    self.selectedDate.text = strDate
//    

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
