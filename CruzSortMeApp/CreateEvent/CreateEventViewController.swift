//
//  CreateEventViewController.swift
//  CruzSortMeApp
//
//  Created by Admin media on 1/21/17.
//  Copyright © 2017 Gopal Gupta. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

protocol creatEventBackDelegate: class  {
    func sendBoolValue(bool : Bool)
}


class CreateEventViewController: UIViewController ,UIImagePickerControllerDelegate ,UINavigationControllerDelegate ,UITextFieldDelegate {

    @IBAction func backButtonAction(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated:true)
    }
    
    var delegate : creatEventBackDelegate?
    
    @IBOutlet weak var myScroolView: UIScrollView!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventNameTextField: UITextField!
    
    @IBOutlet weak var eventTypeTextField: UITextField!
    @IBAction func uploadEventImageButtonAcrtion(_ sender: UIButton) {
        
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
    @IBOutlet weak var startDateButton: UIButton!
    @IBAction func startDateButtonAction(_ sender: UIButton) {
    }
    @IBOutlet weak var endTimeButton: UIButton!
    
    @IBAction func postEventButttonAction(_ sender: UIButton) {
        
        
        if eventNameTextField.text == "" && eventTypeTextField.text == "" && eventDetailTextField.text == ""  {
            
            let alertVC = UIAlertController(title: "Alert", message: "Please enter the details", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK",style:.default,handler: nil)
            alertVC.addAction(okAction)
            present(alertVC,animated: true,completion: nil)
            
        }  else if startDateButton.titleLabel?.text == "" && startTimeButton.titleLabel?.text == "" && endDateButton.titleLabel?.text == "" && endTimeButton.titleLabel?.text == "" {
            
            let alertVC = UIAlertController(title: "Alert", message: "Please select date and time", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK",style:.default,handler: nil)
            alertVC.addAction(okAction)
            present(alertVC,animated: true,completion: nil)
            
        } else if  eventImageView.image == nil {
            
            let alertVC = UIAlertController(title: "Alert", message: "Please select event Image", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK",style:.default,handler: nil)
            alertVC.addAction(okAction)
            present(alertVC,animated: true,completion: nil)
            
        }else  {
            self.postEventApi()
        }
        
        
    }
    @IBOutlet weak var postEventbutton: UIButton!
    @IBAction func endTimeButtonAction(_ sender: UIButton) {
    }
    @IBOutlet weak var eventDetailTextField: UITextField!
    @IBAction func endDateButtonAction(_ sender: UIButton) {
    }
    @IBOutlet weak var endDateButton: UIButton!
    @IBAction func startTimebuttonAction(_ sender: UIButton) {
    }
    @IBOutlet weak var startTimeButton: UIButton!
    
    let imagePicker = UIImagePickerController()
    var userIdString : String!
    var groupImage : UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker.delegate  = self
        self.eventDetailTextField.delegate = self
        self.eventNameTextField.delegate = self
        self.eventTypeTextField.delegate = self

        let userid = defaults.string(forKey: "userId")
        self.userIdString = userid!
        print("self.userid \(self.userIdString)")
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CreateGroupViewController.gestureFunction))
        myScroolView.addGestureRecognizer(tapGesture)

        // Do any additional setup after loading the view.
    }
    
    func gestureFunction() {
        self.eventTypeTextField.resignFirstResponder()
        self.eventDetailTextField.resignFirstResponder()
        self.eventNameTextField.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage  {
            self.eventImageView.contentMode = .scaleAspectFit
            self.eventImageView.image = pickedImage
            
            DispatchQueue.global().async(execute: {
                self.setImage(image: pickedImage)
            })
            print("self.groupImage \(self.groupImage)")
            print("pickedImage \(pickedImage)")
            
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


    func  postEventApi() {
        if currentReachabilityStatus != .notReachable {
            let headers: HTTPHeaders = [
                "Accept": "application/json"
            ]
            let parameter = ["user_id": "\(self.userIdString!)",
                             " event_name" : "\(self.eventNameTextField.text!)",
                             "description" : "\(self.eventDetailTextField.text!)",
                             "address" : "\(self.eventTypeTextField.text!)",
                             " event_start_time" : "\(self.startTimeButton.titleLabel?.text!)",
                             "event_end_time" : "\(self.endTimeButton.titleLabel?.text!)",
                             "event_add_date" : "\(self.startDateButton.titleLabel?.text!)",
                             " event_end_date" : "\(self.endDateButton.titleLabel?.text!)"
                             ]
            print("parameter is \(parameter)")
            
            let image = self.groupImage!
            print("imagefh \(image)")
            let   imagedata  = UIImagePNGRepresentation(image)
            print("imageDatadd \(imagedata!)")
            hudClass.showInView(view: self.view)
            
            let URL = try! URLRequest(url: "\(baseUrl)createEvent", method: .post, headers: headers)
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(imagedata!, withName: " event_image", fileName: "krish.png", mimeType: "image/png")
                
                for (key, value) in parameter {
                    multipartFormData.append((value.data(using: String.Encoding.utf8)!), withName: key)
                }
            }, with: URL, encodingCompletion: { (encodingResult) in
                
                switch encodingResult {
                case .success(let upload, _, _):
                    print("successess")
                    upload.responseJSON {
                        response in
                        print(response.request! )  // original URL request
                        print(response.response! ) // URL response
                        print(response.data! )     // server data
                        print(response.result)   // result of response serialization
                        
                        hudClass.hide()
                        if let result = response.result.value {
                            
                            let JSON = result as! NSDictionary
                            let responseCode = JSON["CruzSortMe_app"] as! NSDictionary
                            
                            print("response code \(responseCode)")
                            
                            let responseMessage = JSON["res_msg"] as! String
                            print("response message \(responseMessage)")
                            
                            if responseMessage == "Save Successfully" {
                                self.delegate?.sendBoolValue(bool: true)
                                _ = self.navigationController?.popViewController(animated: true)
                                
                            }else {
                                let alertVC = UIAlertController(title: "Alert", message: "some thing went wrong", preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "OK",style:.default,handler: nil)
                                alertVC.addAction(okAction)
                                self.present(alertVC, animated: true, completion: nil)
                            }
                            
                            print("JSON: \(result)")
                            if let JSON = response.result.value {
                                print("JSON: \(JSON)")
                            }
                        }
                    }
                case .failure(let encodingError):
                    hudClass.hide()
                    parentClass.showAlertWithApiFailure()
                    print(encodingError)
                }
            })
        }else {
            parentClass.showAlert()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //  myScrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        eventNameTextField.resignFirstResponder()
        eventTypeTextField.resignFirstResponder()
        eventDetailTextField.resignFirstResponder()
        self.view.endEditing(true)
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField.isEqual(eventDetailTextField ) {
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
