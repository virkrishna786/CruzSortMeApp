//
//  CreateGroupViewController.swift
//  CruzSortMeApp
//
//  Created by Admin media on 1/17/17.
//  Copyright © 2017 Gopal Gupta. All rights reserved.
//

import UIKit
import  AlamofireImage
import  Alamofire
import  SwiftyJSON

class CreateGroupViewController: UIViewController ,UIImagePickerControllerDelegate ,UINavigationControllerDelegate {

    @IBAction func backButtonAction(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    @IBAction func submitButtonAction(_ sender: UIButton) {
    }
    @IBOutlet weak var submitButton: UIButton!
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
    @IBOutlet weak var friendListTableView: UITableView!
    @IBOutlet weak var groupTextField: UITextField!
    @IBOutlet weak var groupImageView: UIImageView! {
        didSet{
            groupImageView.layer.borderWidth = 1
            groupImageView.layer.masksToBounds = false
            groupImageView.layer.borderColor = UIColor.white.cgColor
            groupImageView.layer.cornerRadius = groupImageView.frame.height/2
            groupImageView.clipsToBounds = true
        }
    }
    
    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.signUpApi()

        // Do any additional setup after loading the view.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage  {
            groupImageView.contentMode = .scaleAspectFit
            groupImageView.image = pickedImage
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
    

    
    
    func signUpApi() {
        
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        
//        let parameter = ["": name,
//                        
//                         ]
//        
        
        //  let URL = "http://182.73.133.220/CruzSortMe_Test/Apis/testUpload"
        let image = UIImage(named: "krish.png")
        let   imagedata  = UIImagePNGRepresentation(image!)
        
        let URL = try! URLRequest(url: "http://182.73.133.220/CruzSortMe_Test/Apis/testUpload", method: .post, headers: headers)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imagedata!, withName: "profile_pic", fileName: "krish.png", mimeType: "image/png")
            
//            for (key, value) in parameter {
//                multipartFormData.append((value?.data(using: String.Encoding.utf8)!)!, withName: key)
//            }
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
                        
                        if let result = response.result.value {
                            
                            let JSON = result as! NSDictionary
                            
                            
                            let responseCode = JSON["CruzSortMe_app"] as! NSDictionary
                            
                            print("response code \(responseCode)")
                            
                            let responseMessage = responseCode["res_msg"] as! String
                            print("response message \(responseMessage)")
                            
                            if responseMessage == "upload Successfully" {
                                
                                let userIdString = responseCode["user_id"] as! String
                                defaults.set(userIdString, forKey: "userId")
                                
                               // self.performSegue(withIdentifier: "homeView", sender: self)
                                
                            }else {
                                
                                let alertVC = UIAlertController(title: "Alert", message: "Please enter valid email and password", preferredStyle: .alert)
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
                    print(encodingError)
                }
        })
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
