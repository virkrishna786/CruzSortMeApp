//
//  CommonClass.swift
//  FreeTap
//
//  Created by Quickli on 30/03/16.
//  Copyright © 2016 Quickli. All rights reserved.


let kHeight : CGFloat = 375
let kWidth : CGFloat = 667
//let kClientId = "121724468489-rj2akndnt2fvkntbpgpp5bomqk37p3p8.apps.googleusercontent.com";

import UIKit
// import MBProgressHUD

extension UIViewController {
    
    func alert(message: String) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}


class CommonClass {
    class var sharedInstance: CommonClass {
        struct Static {
            static let instance = CommonClass()
        }
        return Static.instance
    }
}
func showHud() {
        
    }
    
    
//    func alertViewFromApp(messageString strMessage: String)
//    {
//        let alert: UIAlertView = UIAlertView(title: titleMessage, message: strMessage, delegate: self, cancelButtonTitle: "ok")
//        alert.show();
//    }
    
//    func backButton()-> UIButton! {
//        
//        let image = UIImage(named: "backwardImage") as UIImage?
//        let backButton = UIButton()
//        backButton.frame = CGRec((CommonClass.sharedInstance).getXCordinateAccordingToScreenSize(getValue: 10), (CommonClass.sharedInstance).getYCordinateAccordingToScreenSize(getValue: 20), (CommonClass.sharedInstance).getXCordinateAccordingToScreenSize(getValue: 20), (CommonClass.sharedInstance).getYCordinateAccordingToScreenSize(getValue: 20))
//        backButton.setImage(image, for: .normal)
//        return backButton
// //       backButton.addTarget(self, action: #selector(backButtonAction(_:)), forControlEvents: .TouchUpInside)
//    }
    
   
    func getYCordinateAccordingToScreenSize(getValue: CGFloat) -> CGFloat {
        return ((getValue * (UIScreen.main.bounds.size.height))/kHeight)
    }
    
    func getXCordinateAccordingToScreenSize(getValue: CGFloat) -> CGFloat {
        return ((getValue * (UIScreen.main.bounds.size.width))/kWidth)
    }
    
   // MARk :  SETWIDTH 
    
    func setWidth(width: CGFloat) -> CGFloat {
        return (width * (UIScreen.main.bounds.size.height))/kHeight
    }
    
    
    func setHeight(height: CGFloat) -> CGFloat {
        return (height * (UIScreen.main.bounds.size.height))/kHeight
    }
    
    func setFont(fontSize: CGFloat)-> CGFloat {
        return (fontSize * (UIScreen.main.bounds.size.width))/kWidth
    }
    
    //MARK: VALID PHONE NUMBER CHECK
    
    func  noIsValid(phoneNumber : String) -> Bool {
        
        let phoneRegExp = "^((\\+)|(00))[0-9]{6,14}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegExp)
       
        if phoneTest.evaluate(with: phoneNumber){
            
            return true
        }
        return false

    }
    
           
    
    //MARK: - IMAGE RESIZE FUNCTION
//    
//    func ResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
//        let size = image.size
//        
//        let widthRatio  = targetSize.width  / image.size.width
//        let heightRatio = targetSize.height / image.size.height
//        
//        // Figure out what our orientation is, and use that to form the rectangle
//        var newSize: CGSize
//        if(widthRatio > heightRatio) {
//            newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
//        } else {
//            newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
//        }
//        
//        // This is the rect that we've calculated out and this is what is actually used below
//        let rect = CGRectMake(0, 0, newSize.width, newSize.height)
//        
//        // Actually do the resizing to the rect using the ImageContext stuff
//        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
//        image.drawInRect(rect)
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        
//        return newImage!
//    }
    
    
    func convertDateFormater(date: String) -> String
    {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"//this your string date format
//        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        let date = dateFormatter.date(from: date)
        
        
        dateFormatter.dateFormat = "MMM dd,yyyy"///this is you want to convert format
//        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        let timeStamp = dateFormatter.string(from: date!)
        
        return timeStamp
    }

    
    
//    func checkForReachability(notification:NSNotification)
//    {
//        let networkReachability = notification.object as! Reachability;
//        var remoteHostStatus = networkReachability.currentReachabilityStatus
//        hashValue == .NotReachable)
//        {
//            print("Not Reachable")
//        }
//        else if (remoteHostStatus.value == .ReachableViaWiFi)
//        {
//            print("Reachable via Wifi")
//        }
//        else
//        {
//            print("Reachable")
//        }
//    }
    
    //MARK: BUTTON IMAGE INSET
    
    func setImageInsetOfUIButton(buttonWidth : CGFloat, buttonHeight : CGFloat, imageHeight : CGFloat, imageWidth : CGFloat, left : CGFloat, top : CGFloat ) -> UIEdgeInsets {
        
        let insetMake = UIEdgeInsetsMake(top, left, (buttonHeight - imageHeight - top) , (buttonWidth - imageWidth - left))
        return insetMake
        
    }
    
//    func addblurView(view : UIView) -> UIView {
//        
//        let staticView = UIView()
//        staticView.frame = CGRect(x: 0, y: 0, width: self.view.frame.origin.x, height: self.view.frame.origin.y)
//        
//        staticView.backgroundColor = UIColor.init(white: 1.0, alpha: 0.5)
//        //
//        //        let blurEffect = UIBlurEffect(style: .Light)
//        //        let effectView = UIVisualEffectView(effect: blurEffect)
//        //        effectView.frame = staticView.frame
//        //        staticView.addSubview(effectView)
//        //        effectView.alpha = 0
//        //
//        //        UIView.animateWithDuration(0.8) {
//        //            effectView.alpha = 1.0
//        //        }
//        return staticView
//    }
    
    
//    func showViewWithPopUp(view : UIView) -> UIView {
//        
//        view.transform = CGAffineTransformIdentity
//        UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseOut, animations: {() -> Void in
//            view.transform = CGAffineTransformMakeScale(0.01, 0.01)
//            }, completion: {(finished: Bool) -> Void in
//                // do something once the animation finishes, put it here
//                view.hidden = true
//        })
//        return view
//    }
    
    

