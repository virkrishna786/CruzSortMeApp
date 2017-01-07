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
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBAction func datePickerAction(_ sender: UIDatePicker) {
        self.setDateAndTime()
    }
    @IBOutlet weak var CnfirmPasswordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func femaleButtonAction(_ sender: UIButton) {
    }
    @IBOutlet weak var femaleButton: UIButton!
    @IBAction func maleButtonAction(_ sender: UIButton) {
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
        self.signUpApi()
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
    
    let imagePicker = UIImagePickerController()
    let dateFormatter = DateFormatter()
    var dateString : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        self.datePicker.isHidden = true
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }
    
    
    func dismissKeyboard() {
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
        
        let parameter = ["name","krishna",
                         "":""]
    }
    
  // MARK -: set date of birth
    func setDateAndTime() {
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.dateFormat = "dd/MM/YYYY"
        dobButton.titleLabel?.text = dateFormatter.string(from: datePicker.date)
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
