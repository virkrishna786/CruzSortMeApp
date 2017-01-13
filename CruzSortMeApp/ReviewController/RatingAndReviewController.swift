//
//  RatingAndReviewController.swift
//  CruzSortMeApp
//
//  Created by Admin media on 1/13/17.
//  Copyright © 2017 Gopal Gupta. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON



protocol ratingViewControllerDelegate {
    func backFromRatingController(info: Bool)
}


class RatingAndReviewController: UIViewController ,FloatRatingViewDelegate ,UITextFieldDelegate {

    var eventIDString : String! {
        didSet {
            
            print("eventudaksdfhgsd \(eventIDString!)")
        }
        
    }
    var userIDString : String!
    var ratingString : String!
    var delegate: ratingViewControllerDelegate? = nil

    @IBOutlet weak var submitButton: UIButton! {
        didSet {
            self.submitButton.layer.cornerRadius = 25
        }
    }
    @IBAction func submitButtonAction(_ sender: UIButton) {
        DispatchQueue.global(qos: .background).async {
            self.reviewApiHit()
        }
    }
    @IBOutlet weak var reviewTextField: UITextField!
    @IBOutlet weak var starRatingView: FloatRatingView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reviewTextField.delegate = self
        
        let useriDstring = defaults.string(forKey: "userId")
        self.userIDString = useriDstring!
        print("userid \(useriDstring!)")
        print("userId \(self.userIDString)")
        
        self.reviewTextField.layer.cornerRadius = 5
        self.starRatingView.emptyImage = UIImage(named: "starGrayIcon")
        self.starRatingView.fullImage = UIImage(named: "starLightIcon")
        self.starRatingView.delegate = self
        self.starRatingView.contentMode = UIViewContentMode.scaleAspectFit
        self.starRatingView.maxRating = 5
        self.starRatingView.minRating = 1
        self.starRatingView.rating = 5
        self.starRatingView.editable = true
        self.starRatingView.halfRatings = true
        self.starRatingView.floatRatings = false

        // Do any additional setup after loading the view.
    }
    
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
        self.ratingString = NSString(format: "%.2f", self.starRatingView.rating) as String
        print("ratingString \(self.ratingString!)")
       
    }
    
    
   
        
        // print("floating value : \(NSString(format: "%.2f", self.floatRatingView.rating) as String)")
        // self.liveLabel.text = NSString(format: "%.2f", self.floatRatingView.rating) as String
 
    
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Float) {
        print("krishdsdgfasd")
    }
    
    func reviewApiHit() {
        
        let url = "http://182.73.133.220/CruzSortMe/Apis/saveRating"
        
        let parameter = ["rating" : self.ratingString!,
                         "user_id" : self.userIDString!,
                         "event_id" : "1",
                         "review" : reviewTextField.text!]
        
        print("parameter \(parameter)")
        
        
        Alamofire.request( url, method : .post , parameters: parameter ).responseJSON { (responseObject) -> Void in
            
            print(responseObject)
            
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                
                let  savedDict = resJson["CruzSortMe_app"].dictionary!
                
                let  res_message = savedDict["res_msg"]!.string
                
                if res_message == "Save Successfully" {
                    
                    let dataResponse = resJson["CruzSortMe"].array
                    
                    let alertVC = UIAlertController(title: "Alert", message: "Your review has been saved successfully", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK",style:.default,handler: self.alertAction)
                    alertVC.addAction(okAction)
                    self.present(alertVC, animated: true, completion: nil)
                    
                    print("dataArray \(dataResponse)")
                }else {
                    
                    let alertVC = UIAlertController(title: "Alert", message: "Some thing went wrong", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK",style:.default,handler: nil)
                    alertVC.addAction(okAction)
                    self.present(alertVC, animated: true, completion: nil)
                }
                
                
            }
            if responseObject.result.isFailure {
                let error  = responseObject.result.error!  as NSError
                print("\(error)")
                
            }
        }
    }

    
    func alertAction(action : UIAlertAction) {
    self.dismiss(animated: true, completion: nil)
        
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
