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

class EditProfielViewController: UIViewController {
    var boolValue = 0

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
    @IBOutlet weak var profileImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addChildViewController(appDelegate.menuTableViewController)
        self.apiCall()

        // Do any additional setup after loading the view.
    }

    
    func  apiCall() {
        if currentReachabilityStatus != .notReachable {
            
            let image = UIImage(named : "icon1.png")
            print("imagefh \(image)")
            let   imagedata  = UIImageJPEGRepresentation(image!, 0.2)
            print("imageDatadd \(imagedata!)")
            hudClass.showInView(view: self.view)
            
            let URL = try! URLRequest(url: "http://182.73.133.220/CruzSortMe/Apis/testUpload", method: .post)
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
