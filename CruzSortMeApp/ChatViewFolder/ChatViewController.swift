//
//  ChatViewController.swift
//  CruzSortMeApp
//
//  Created by Admin media on 2/1/17.
//  Copyright © 2017 Gopal Gupta. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import Kingfisher
import SwiftyJSON

class ChatViewController: UIViewController ,UICollectionViewDelegate ,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout  ,UITextFieldDelegate {

    @IBAction func backButtonAction(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    @IBAction func sendButtonAction(_ sender: UIButton) {
        
        if chatTextField.text != "" {
            self.sendMessage()
    }
    
    }
    @IBOutlet weak var chatTextField: UITextField!{
        didSet {
            chatTextField.layer.cornerRadius = 5.0
        }
    }

    @IBOutlet weak var ChatCollectionView: UICollectionView!
    
    var messages = [AnyObject]()
    var people = [ChatArrayClass]()
    var doctorCallingDict : NSDictionary?

    var PatientDetailDictianry : NSDictionary!
    let reuseIdentifier = "MyCell"
    let newIdentifier = "MyCellR"
    var historyDict : NSDictionary!
    var  userIdString : String!
    var friendIdString : String!
    var numberofEvents : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let useriDstring = defaults.string(forKey: "userId")
        self.userIdString =  useriDstring!
        print("userid \(useriDstring!)")
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(ChatViewController.selfViewTapped))
        self.view.addGestureRecognizer(tapGestureRecognizer)

        self.ChatCollectionView.register(UINib(nibName: "BubbleCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        self.ChatCollectionView.register(UINib(nibName: "RightbubbleCell", bundle: nil), forCellWithReuseIdentifier: newIdentifier)

          self.chatHistory()
        // Do any additional setup after loading the view.
    }
    
    func selfViewTapped(img : AnyObject) {
        chatTextField.resignFirstResponder()
    }
    
    
    //MARK: - KEYBOARD METHOD
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            //self.view.frame.origin.y -= keyboardSize.height
            self.view.frame.size.height -= keyboardSize.height
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            // self.view.frame.origin.y += keyboardSize.height
            self.view.frame.size.height += keyboardSize.height
        }
    }

    func chatHistory() {
        
            if currentReachabilityStatus != .notReachable {
                
                hudClass.showInView(view: self.view)
                let url = "\(baseUrl)chatHistory"
                
                hudClass.showInView(view: self.view)
                
                let parameter = ["user_id": "\(self.userIdString!)",
                                 "friend_id" : "\(self.friendIdString!)",
                                 "end_value" : "0"]
                
                print("chathistry parameter : \(parameter)")
                
                Alamofire.request( url, method : .post , parameters : parameter).responseJSON { (responseObject) -> Void in
                    
                    print(responseObject)
                    
                    if responseObject.result.isSuccess {
                       // self.chatFriendListTableView.isHidden = false
                        hudClass.hide()
                        let resJson = JSON(responseObject.result.value!)
                        
                        let  res_message = resJson["res_msg"].string
                        
                        if res_message == "Show All Conversation" {
                            
                            let dataResponse = resJson["CruzSortMe"].array
                            
                            self.numberofEvents = dataResponse?.count
                            print("numberofEvents \(self.numberofEvents)")
                            
                            for eventArray in dataResponse! {
                                let eventArrayClass = ChatArrayClass()
                                
                                eventArrayClass.messageIdString = eventArray["msg_id"].string
                                eventArrayClass.senderIdString = eventArray["sender_id"].string
                                eventArrayClass.textMessageString = eventArray["message"].string
                                eventArrayClass.messageTimingString = eventArray["send_date"].string
                                eventArrayClass.recieverIdString = eventArray["receiver"].string
                                
                                self.people.append(eventArrayClass)
                            }
                            print("homeEventArray : \(self.people)")
                            print("dataArray \(dataResponse)")
                        }else {
                            self.ChatCollectionView.isHidden = true
                            let label = UILabel()
                            self.view.addSubview(parentClass.setBlankView(label: label))
                        }
                        
                        DispatchQueue.main.async {
                            self.ChatCollectionView.reloadData()
                        }
                        print("dsfs \(resJson)")
                    }
                    if responseObject.result.isFailure {
                        hudClass.hide()
                        let error  = responseObject.result.error!  as NSError
                        parentClass.showAlertWithApiFailure()
                        print("failuredata \(error)")
                        
                    }
                }
            }else {
                parentClass.showAlert()
            }
    }
    
    func reloadCollectionView(){
        self.ChatCollectionView.reloadData()
        
        if self.ChatCollectionView.contentSize.height > self.ChatCollectionView.frame.size.height {
            
            ChatCollectionView.scrollToItem(at: (NSIndexPath(row: self.people.count - 1, section: 0)) as IndexPath, at: UICollectionViewScrollPosition.bottom, animated: true)
        }
    }
    
    func updateCollecttionviewChat(){
        self.ChatCollectionView.reloadData()
        
        let numberOfSections = ChatCollectionView.numberOfSections
        let numberOfRows = ChatCollectionView.numberOfItems(inSection: numberOfSections-1)
        
        
        if numberOfRows > 0 {
            let indexPath = NSIndexPath(row: numberOfRows - 1, section: (numberOfSections-1))
            ChatCollectionView.scrollToItem(at: indexPath as IndexPath, at: UICollectionViewScrollPosition.bottom, animated: true)
        }
        if self.ChatCollectionView.contentSize.height > self.ChatCollectionView.frame.size.height {
           ChatCollectionView.scrollToItem(at: (NSIndexPath(row: self.people.count - 1, section: 0)) as IndexPath, at: UICollectionViewScrollPosition.bottom, animated: true)
        }
    }
    

    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.people.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let  messageTextString = people[indexPath.item].textMessageString
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: messageTextString!).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 18)], context: nil)
        
        return CGSize(width: view.frame.width, height: estimatedFrame.height + 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(8, 0, 0, 0)

    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = UICollectionViewCell()
        print("cell\(cell)")
        
        let meesageSingle = people[indexPath.item]
        let senderIDstring = meesageSingle.senderIdString!
        
        print("self.userddsfg \(self.userIdString)")
        print("self.sendeidStigfn \(senderIDstring)")
        
        if    (self.userIdString! ==  senderIDstring) {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: newIdentifier,
                                                          for: indexPath) as! RIghtBubbleCell
            
            let dateString = meesageSingle.messageTimingString!
            
            let blankString = "   "
            
            let yourAttributes = [NSForegroundColorAttributeName: UIColor.gray, NSFontAttributeName: UIFont.systemFont(ofSize: 17)]
            let yourSecondAttribtes = [NSForegroundColorAttributeName: UIColor.gray ,NSFontAttributeName: UIFont.systemFont(ofSize: 8)]
            
            let yourOtherAttributes = [NSForegroundColorAttributeName: UIColor.gray, NSFontAttributeName: UIFont.systemFont(ofSize: 10)]
            
            let partOne = NSMutableAttributedString(string: meesageSingle.textMessageString!, attributes: yourAttributes)
            let partwo = NSMutableAttributedString(string: blankString, attributes: yourSecondAttribtes)
            let partThree = NSMutableAttributedString(string: dateString, attributes: yourOtherAttributes)
            
            let combination = NSMutableAttributedString()
            combination.append(partOne)
            combination.append(partwo)
            combination.append(partThree)
            
            cell.chatRightLabel!.attributedText = combination
            
            cell.chatRightLabel.sizeToFit()
            cell.chatRightLabel.layoutIfNeeded()
            
            
            return cell
        }else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                          for: indexPath) as! BubbleChatCell
            let dateString = meesageSingle.messageTimingString!
            
            let blankString = "   "
            
            let yourAttributes = [NSForegroundColorAttributeName: UIColor.gray, NSFontAttributeName: UIFont.systemFont(ofSize: 17)]
            let yourSecondAttribtes = [NSForegroundColorAttributeName: UIColor.gray ,NSFontAttributeName: UIFont.systemFont(ofSize: 8)]
            
            let yourOtherAttributes = [NSForegroundColorAttributeName: UIColor.gray, NSFontAttributeName: UIFont.systemFont(ofSize: 10)]
            
            let partOne = NSMutableAttributedString(string: meesageSingle.textMessageString!, attributes: yourAttributes)
            let partwo = NSMutableAttributedString(string: blankString, attributes: yourSecondAttribtes)
            let partThree = NSMutableAttributedString(string: dateString, attributes: yourOtherAttributes)
            
            let combination = NSMutableAttributedString()
            combination.append(partOne)
            combination.append(partwo)
            combination.append(partThree)
            
            cell.leftBubbleChatLable!.attributedText = combination
            
            DispatchQueue.main.async(execute: {() -> Void in
                cell.leftBubbleChatLable.sizeToFit()
                cell.leftBubbleChatLable.layoutIfNeeded()
            })

            
            cell.leftBubbleChatLable.sizeToFit()
            cell.leftBubbleChatLable.layoutIfNeeded()

            
            
           return cell
        }
        
      //  return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            print("cell.. \(cell)")
            chatTextField.resignFirstResponder()
            // performSegueWithIdentifier("showDetail", sender: cell)
        } else {
            // Error indexPath is not on screen: this should never happen.
        }
    }
    
    
    func sendMessage() {
        
        if currentReachabilityStatus != .notReachable {
            
            hudClass.showInView(view: self.view)
            let url = "\(baseUrl)sendMessageThroughAPN"
            
            hudClass.showInView(view: self.view)
            
            let parameter  = ["sender_id": "\(self.userIdString!)",
                "receiver_id" : "\(self.friendIdString!)",
                "messages" : "\(self.chatTextField.text!)" ]
            
            print("parameter \(parameter)")
            
            print("chathistry parameter : \(parameter)")
            
            Alamofire.request( url, method : .post , parameters : parameter).responseJSON { (responseObject) -> Void in
                
                print(responseObject)
                
                if responseObject.result.isSuccess {
                    // self.chatFriendListTableView.isHidden = false
                    hudClass.hide()
                    let resJson = JSON(responseObject.result.value!)
                    print("resJosn  dsfdsg \(resJson)")
                    
                    let  res_message = resJson["msg_title"].string
                    
                    
                    print("rs_message \(res_message)")
                    
                    if res_message == "You have received a message" {
                        
                           let messageDict = ChatArrayClass()
                        let messahetiming = resJson["masg_date"].string
                        
                        messageDict.textMessageString = parameter["messages"]
                        messageDict.recieverIdString = parameter["receiver_id"]
                        messageDict.senderIdString = parameter["sender_id"]
                        messageDict.messageTimingString = messahetiming!
                        
                            self.people.append(messageDict)
                        
                        print("homeEventArray : \(self.people)")
                        
                        DispatchQueue.main.async {
                            self.reloadCollectionView()
                        }
                       // print("dataArray \(dataResponse)")
                    }else {
                        hudClass.hide()
//                        self.ChatCollectionView.isHidden = true
//                        let label = UILabel()
//                        self.view.addSubview(parentClass.setBlankView(label: label))
                    }
                    
                }else if responseObject.result.isFailure {
                    hudClass.hide()
                    let error  = responseObject.result.error!  as NSError
                    parentClass.showAlertWithApiFailure()
                    print("failuredata \(error)")
                    
                }
            }
        }else {
            parentClass.showAlert()
        }
        
        DispatchQueue.main.async {
            self.reloadCollectionView()
        }
        chatTextField.text = ""
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
