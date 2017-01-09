//
//  Validator.swift
//  Ted Fred
//
//  Created by Umesh on 13/09/15.
//  Copyright (c) 2015 Relianttekk. All rights reserved.
//

import Foundation
import UIKit

class Validator: NSObject
{
    //MARK: Phone number  validator
    class func validatePhone(yourNumber:NSString)->Bool
    {
        NSLog("%@",yourNumber);
        
        let PHONE_REGEX = "[0-9]{6,14}$"
        
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        
        let result =  phoneTest.evaluate(with: yourNumber)
        
        return result
    }
    
//    class func checkStringIsBlankOrNot( str:String?)->String
//    {
//        
//        if( str == NSNull() || str == nil )
//        {
//            str = "";
//            
//        }
//        return str!;
//    
//    }
    
    
    class func selectionToggleOnButton(btn : UIButton)
    {
        if(btn.isSelected == true)
        {btn.isSelected = false;}
        else
        { btn.isSelected = true; }
    }
    

    

//    class func decision(txtField: UITextField,string:String)->Bool
//    {
//        var invalidCharacters:NSCharacterSet = NSCharacterSet(charactersIn: "0123456789.").inverted as NSCharacterSet
//        
//        if ((txtField.text!.lowercaseString.range(of: ".") != nil)
//        do {
//            invalidCharacters = NSCharacterSet(charactersIn: "0123456789").inverted as NSCharacterSet
//        }
//        if((string.rangeOfCharacter(from: invalidCharacters as CharacterSet)) != nil)
//        {
//            return false;
//        }
//        else
//        {
//            return true;
//            
//        }
//    }
//    
//    
    
    
    //MARK: email validator
    class func validateEmailAddress(yourEmail:NSString)->Bool
    {
        let emailRegex:String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        let email:NSPredicate = NSPredicate(format: "SELF MATCHES %@",emailRegex);
        return email.evaluate(with: yourEmail);
    }
    
}







