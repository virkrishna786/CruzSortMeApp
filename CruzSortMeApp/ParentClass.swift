//
//  ParentClass.swift
//  CruzSortMeApp
//
//  Created by Admin media on 1/10/17.
//  Copyright © 2017 Gopal Gupta. All rights reserved.
//

import Foundation
import ReachabilitySwift


class ParentClass : NSObject {
    
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
    
    func setBlankView(label : UILabel)  -> UILabel {
        
        let customView = UILabel(frame: CGRect(x: 50, y: 200, width: 200, height: 30))
        customView.backgroundColor = UIColor.clear
        customView.text = "No Record Found"
        customView.textAlignment = NSTextAlignment.center
        customView.textColor = UIColor.white
        
        return customView
    }
    
    
    
    //MARK: CHECK INTERNET CONNECTION
    
    func checkInternetConnection() -> Bool {
        
        var reachability: Reachability
        do {
            reachability = try Reachability.init()!
            //  try reachability.startNotifier()
            
        } catch {
            print("Unable to create Reachability")
            return false
        }
        
        
        //       NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(CommonClass.checkForReachability(_:)), name: ReachabilityChangedNotification, object: nil);
        if (reachability.currentReachabilityStatus == .notReachable)
        {
            return false
        }
        else
        {
            return true
        }
        
    }

    
}


