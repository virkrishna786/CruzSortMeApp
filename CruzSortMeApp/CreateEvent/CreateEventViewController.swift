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

protocol creatEventBackDelegate : class{
    func sendBoolValue(bool : Bool)
}


class CreateEventViewController: UIViewController ,UIImagePickerControllerDelegate ,UINavigationControllerDelegate ,UITextFieldDelegate {

    @IBAction func dateAndTimePickerValueChanged(_ sender: UIDatePicker) {
              self.setDateAndTime()
    }
    @IBOutlet weak var dateAndTimePicker: UIDatePicker!{
        didSet{
            dateAndTimePicker.backgroundColor = UIColor.red
        }
    }
    @IBAction func backButtonAction(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated:true)
    }
    
    var delegate : creatEventBackDelegate?
    
    @IBOutlet weak var myScroolView: UIScrollView!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventNameTextField: UITextField!
    
    @IBOutlet weak var eventTypeTextField: UITextField!
    @IBAction func uploadEventImageButtonAcrtion(_ sender: UIButton) {
        
        UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    @IBOutlet weak var startDateButton: UIButton!{
        didSet {
        self.startDateButton.tag = 100
        }
    }
    @IBAction func startDateButtonAction(_ sender: UIButton) {
        self.dateAndTimePicker.isHidden = false
        self.dateAndTimePicker.datePickerMode = UIDatePickerMode.date
        self.tagButtonValue = sender.tag
        print("krihsna\(self.tagButtonValue!)")
    }
    @IBOutlet weak var endTimeButton: UIButton!{
        didSet {
            self.endTimeButton.tag = 103

        }
    }

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
        self.dateAndTimePicker.isHidden = false
        self.dateAndTimePicker.datePickerMode = UIDatePickerMode.time
        self.tagButtonValue = sender.tag


    }
    @IBOutlet weak var eventDetailTextField: UITextField!
    @IBAction func endDateButtonAction(_ sender: UIButton) {
        self.dateAndTimePicker.isHidden = false
        self.dateAndTimePicker.datePickerMode = UIDatePickerMode.date
        self.tagButtonValue = sender.tag


    }
    @IBOutlet weak var endDateButton: UIButton!{
        didSet {
            self.endDateButton.tag = 102
            
        }
    }

    @IBAction func startTimebuttonAction(_ sender: UIButton) {
        self.dateAndTimePicker.isHidden = false
        self.dateAndTimePicker.datePickerMode = UIDatePickerMode.time
        self.tagButtonValue = sender.tag


    }
    @IBOutlet weak var startTimeButton: UIButton!{
        didSet {
            self.startTimeButton.tag = 101
        }
    }

    
    let imagePicker = UIImagePickerController()
    let dateFormatter = DateFormatter()
    var userIdString : String!
    var groupImage : UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker.delegate  = self
        self.eventDetailTextField.delegate = self
        self.eventNameTextField.delegate = self
        self.eventTypeTextField.delegate = self
        self.dateAndTimePicker.isHidden = true

        let userid = defaults.string(forKey: "userId")
        self.userIdString = userid!
        print("self.userid \(self.userIdString)")
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CreateGroupViewController.gestureFunction))
        myScroolView.addGestureRecognizer(tapGesture)

        // Do any additional setup after loading the view.
    }
    
    func gestureFunction() {
        self.dateAndTimePicker.isHidden = true
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
       
            let eventEndTimeStringK  = self.endTimeButton.titleLabel?.text!
            let eventEndDateTimingK = self.endDateButton.titleLabel?.text!
            let eventStartTimingStringK = self.startTimeButton.titleLabel?.text!
            let eventStartDateStringK =   self.startDateButton.titleLabel?.text!
            
            
            let parameter = ["user_id": "\(self.userIdString!)",
                             " event_name" : "\(self.eventNameTextField.text!)",
                             "description" : "\(self.eventDetailTextField.text!)",
                             "address" : "\(self.eventTypeTextField.text!)",
                             " event_start_time" : eventStartTimingStringK!,
                             "event_end_time" : eventEndTimeStringK!,
                             "event_add_date" : eventStartDateStringK!,
                             " event_end_date" : eventEndDateTimingK!
                             ]
            print("parameter is \(parameter)")
            
            let image = self.groupImage
            print("imagefh \(image)")
            let   imagedata  = UIImageJPEGRepresentation(image!, 0.2)
            print("imageDatadd \(imagedata!)")
            hudClass.showInView(view: self.view)
            
            let URL = try! URLRequest(url: "\(baseUrl)createEvent", method: .post)
            print("URLS : \(URL)")
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(imagedata!, withName: " event_image", fileName: "krish.jpg", mimeType: "image/png/jpeg")
                
                for (key, value) in parameter {
                    multipartFormData.append((value.data(using: String.Encoding.utf8)!), withName: key)
                }
            }, with: URL, encodingCompletion: { (encodingResult) in
                
                switch encodingResult {
                case .success(let upload, _, _):
                    print("successess")
                    
                    upload.responseString{
                        response in
                        print(response.request! )  // original URL request
                        print(response.response! ) // URL response
                        print(response.data! )     // server data
                        print(response.result)   // result of response serialization
                        
                        switch  response.result {
                            
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
                            
                            if responseMessage == "Save Successfully" {
                                hudClass.hide()
                                print("save successFully")
                                
                                self.delegate?.sendBoolValue(bool: true)
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
            parentClass.showAlert()
        }
    }
    
    
    // MARK -: set date of birth
    var tagButtonValue : Int!
    func setDateAndTime() {
        dateFormatter.dateStyle = DateFormatter.Style.short
        
        if self.tagButtonValue == 100 {
//            dateAndTimePicker.datePickerMode = UIDatePickerMode.date
            dateFormatter.dateFormat = "dd-MM-YYYY"
            self.startDateButton.titleLabel?.text = dateFormatter.string(from: dateAndTimePicker.date)
            
        }else if self.tagButtonValue == 101{
//            dateAndTimePicker.datePickerMode = UIDatePickerMode.time
            dateFormatter.dateFormat = "HH:mm"
            self.startTimeButton.titleLabel?.text = dateFormatter.string(from: dateAndTimePicker.date)

        }else if self.tagButtonValue == 102 {
//            dateAndTimePicker.datePickerMode = UIDatePickerMode.date
            dateFormatter.dateFormat = "dd-MM-YYYY"
            self.endDateButton.titleLabel?.text = dateFormatter.string(from: dateAndTimePicker.date)

        }else if self.tagButtonValue == 103 {
//            dateAndTimePicker.datePickerMode = UIDatePickerMode.time
            dateFormatter.dateFormat = "HH:mm"
            self.endTimeButton.titleLabel?.text = dateFormatter.string(from: dateAndTimePicker.date)

        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // myScrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
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
