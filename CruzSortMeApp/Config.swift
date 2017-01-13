//
//  Config.swift
//  Visit
//
//  Created by Chetan Anand on 05/07/16.
//  Copyright © 2016 Chetan Anand. All rights reserved.
//

import Foundation
import UIKit
// import MBProgressHUD
//import Device_swift


//let kAppVersion = 107
//let projenvironment = 1// 1 for Stagging, 2 for Live
//
//#if defined(projenvironment) && projenvironment == 1
//let BaseUrl = "http://staging.quickli.com/"
//let WebSocketUrl = "ws://staging.quickli.com/websocket"
// 
//    #endif


// PROD CREDENTIAlS AND API URLS 


let openTokStage = "45440642"  // opentok production key
let productionUrl = "web.getvisitapp.com" // PRODUCTION URL
let baseUrl = "https://api.getvisitapp.com/apiv2" //  PROD API CALL URL
let baseImageUrl = "https://api.getvisitapp.com"


let merchant_MID = "getvis13942711136815"  // PROD PAYTM DETAILS
let paytmEnvironMent = "PROD"
let merchant_website = "Visitwap"
let paytmIndusty_type = "Retail110"
let paytm_DomainType = "pguat.paytm.com"

let PushKeyFOrPubNub = "pub-c-fb8ac7e3-75bf-4396-bf14-77215f8b9419"  //  PROD  PUSHKEY pubnub
let SUbKeyForPubNub  =  "sub-c-78deef00-680f-11e5-a57f-0619f8945a4f"  // PROD SUBKEY pubnub

func print(items: Any..., separator: String = " ", terminator: String = "\n") {
   // Swift.print(items[0], separator:separator, terminator: terminator)
}
//
//// STAGING CREDENTIALS AND API URLS
//
//let openTokStage =  "45702452" // STAGE OPENTOK KEY
//let baseUrl = "https://api.samuraijack.xyz/apiv2" // for staging  API url
//let baseImageUrl = "https://api.samuraijack.xyz"
//
//let merchant_MID = "Visiti30926426902607" // stage key for paytm
//let paytmEnvironMent = "STAGE"
//let merchant_website = "Visitinterwap"
//let paytmIndusty_type = "Retail"
//let paytm_DomainType = "pguat.paytm.com"
//
//let PushKeyFOrPubNub = "pub-c-b8b14417-cff1-4e64-aa43-b41a777352cf"
//let SUbKeyForPubNub  =  "sub-c-42db9ed2-315c-11e6-9327-02ee2ddab7fe"


// END OF K
let color_app_backgroundView_trasnparent =  UIColor(red: 121.0/255, green:106.0/255, blue: 145.0/255, alpha: 0.6)
let appDelegate = UIApplication.shared.delegate as! AppDelegate
let defaults =  UserDefaults.standard
// let deviceType = UIDevice.currentDevice().deviceType


//// show hud
//#define showHud  dispatch_async(dispatch_get_main_queue(), ^{[MBProgressHUD showHUDAddedTo:self.view animated:YES];})
//// hide hud
//#define hideHud  dispatch_async(dispatch_get_main_queue(), ^{[MBProgressHUD hideHUDForView:self.view animated:YES];})


//var vc:UIViewController?
var window:UIWindow!

// show  hud

//let showHud = dispatch_async(dispatch_get_main_queue(), {() -> Void in
//    MBProgressHUD.showHUDAddedTo(window, animated: true)
//})
//let hideHud = dispatch_async(dispatch_get_main_queue(), {() -> Void in
//    MBProgressHUD.hideHUDForView(window, animated: true)
//})

