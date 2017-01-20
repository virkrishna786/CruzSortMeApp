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

class CreateGroupViewController: UIViewController ,UIImagePickerControllerDelegate ,UINavigationControllerDelegate  ,UITableViewDataSource ,UITableViewDelegate ,UITextFieldDelegate{

    @IBAction func backButtonAction(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    @IBAction func submitButtonAction(_ sender: UIButton) {
        hudClass.showInView(view: self.view)
        self.makeGroupApi()
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
    @IBOutlet weak var groupTextField: UITextField! {
        didSet{
            self.groupTextField.layer.cornerRadius = 5
        }
    }
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
    
    var userIdString : String!
    var numberOfEvents : Int!
    var friendIdString : String!
    let cellIdentifier = "friendListCellTypee"
    var friendsListInGroupArray = [FriendListClass]()
    var selectedInterestArray = [String]()
    var groupImage : UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imagePicker.delegate  = self
        self.friendListTableView.delegate = self
        self.friendListTableView.dataSource = self
        let userid = defaults.string(forKey: "userId")
        self.userIdString = userid!
        print("self.userid \(self.userIdString)")
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CreateGroupViewController.gestureFunction))
        self.view.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
        
        self.friendListTableView.register(UINib(nibName : "FriendListCell" ,bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.friendListApi()

        // Do any additional setup after loading the view.
    }
    
    
    func gestureFunction() {
        self.groupTextField.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage  {
            groupImageView.contentMode = .scaleAspectFit
            groupImageView.image = pickedImage
         //   self.groupImage = pickedImage
            
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
    
    //MARK: - FriendListApi
    
    func friendListApi() {
        
        let url = "http://182.73.133.220/CruzSortMe/Apis/friendList"
        
        let paramter = ["user_id": self.userIdString!]
        
        Alamofire.request( url, method : .post  ,parameters : paramter).responseJSON { (responseObject) -> Void in
            
            print(responseObject)
            
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                
                let dataResponse = resJson["Friend"].array
                
                self.numberOfEvents = dataResponse?.count
                print("numberofEvents \(self.numberOfEvents)")
                
                for eventArray in dataResponse! {
                    let eventArrayClass = FriendListClass()
                    
                    eventArrayClass.friendNameString = eventArray["username"].string
                    eventArrayClass.friendIdString = eventArray["friend_id"].string
                    eventArrayClass.friendProfileImage = eventArray["profile_image"].string
                    self.friendsListInGroupArray.append(eventArrayClass)
                }
                print("homeEventArray : \(self.friendsListInGroupArray)")
                print("dataArray \(dataResponse)")
                DispatchQueue.main.async {
                    self.friendListTableView.reloadData()
                }
                
                print("dsfs \(resJson)")
            }
            if responseObject.result.isFailure {
                let error  = responseObject.result.error!  as NSError
                print("\(error)")
                
            }
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        if shouldShowSearchResults {
        //            return marrFilteredFriendList.count
        //        }
        //        else {
        //            return friendsListArray.count
        //        }
        
        return self.friendsListInGroupArray.count
        
        //        if tableView == self.searchDisplayController!.searchResultsTableView {
        //            return self.marrFilteredFriendList.count
        //        } else {
        //            return self.friendsListArray.count
        //        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)! as! FriendListCellType
        cell.accessoryType = cell.isSelected ? .checkmark : .none
        cell.selectionStyle = .none
        
        cell.blockButton.isHidden = true
        let eventList = friendsListInGroupArray[indexPath.row]
        print("eventLsit\(eventList)")

        cell.friendNameLabel.text = eventList.friendNameString!
        
        print("event imageString = \(eventList.friendProfileImage!)")
        let URL = NSURL(string: "\(eventList.friendProfileImage!)")
        print("urlsfgds \(URL)")
        let mutableUrlRequest = NSMutableURLRequest(url: URL! as URL)
        mutableUrlRequest.httpMethod = "get"
        
        mutableUrlRequest.setValue("image/jpeg", forHTTPHeaderField: "Accept")
        
        
        let headers = [
            "Accept"  :  "image/jpeg"
        ]
        print(" headers \(headers)")
        print("mutable Request : \(mutableUrlRequest)")
        //  request.addAcceptableImageContentTypes(["image/jpeg"])
        
        Alamofire.request("\(URL!)").responseImage { response in
            debugPrint(response)
            
            print("adsfdfs \(response.request!)")
            print("dskjfd \(response.response!)")
            print(" response.result \(response.result)")
            
            if let image = response.result.value {
                DispatchQueue.global().async(execute: {
                    
                    if let cellToUpdate = tableView.cellForRow(at: indexPath) {
                        
                        print("\(cellToUpdate)")
                        cell.friendProfileImageView.image = image
                    }
                    
                })
                
            }
        }
        
        
        //  self.IntrestIdString = eventList.interestId!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("dfgdjksgksdgjks")
                
       // let indexPath = tableView.indexPathForSelectedRow //optional, to get from any UIButton for example
        
        let eventArray = friendsListInGroupArray[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath) as! FriendListCellType
            cell.accessoryType = .checkmark
            self.selectedInterestArray.append((eventArray.friendIdString)!)
        
        
            print("selecgted \(self.selectedInterestArray)")
        
//        let eventList = friendsListInGroupArray[indexPath.row]
//        self.friendIdString = eventList.friendIdString!
       // self.performSegue(withIdentifier: "friendDetail", sender: self)
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FriendListCellType
        cell.accessoryType = .none
        self.selectedInterestArray.remove(at: indexPath.row)
        
        print("\(self.selectedInterestArray)")

        
    }
    
    
    
    func makeGroupApi() {
        
        if currentReachabilityStatus != .notReachable {
        
        
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        
        let stringArray = selectedInterestArray
        let string = stringArray.joined(separator: ",")
        print("stringd \(string)")
        
        
        let parameter = ["user_id": self.userIdString!,
                         "group_friend_id" : string,
                         "group_name" : self.groupTextField.text!,
                         ]
        print("parameter is \(parameter)")
        
        
        let image = self.groupImage!
        print("imagefh \(image)")
        let   imagedata  = UIImagePNGRepresentation(image)
        print("imageDatadd \(imagedata!)")
        
        let URL = try! URLRequest(url: "http://182.73.133.220/CruzSortMe/Apis/createGroup", method: .post, headers: headers)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imagedata!, withName: "group_img", fileName: "krish.png", mimeType: "image/png")
            
            for (key, value) in parameter {
                multipartFormData.append((value.data(using: String.Encoding.utf8)!), withName: key)
            }
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
                            
                            if responseMessage == "Save Successfully" {
                                _ = self.navigationController?.popViewController(animated: true)
                                
                            }else {
                                let alertVC = UIAlertController(title: "Alert", message: "some thing went wrong", preferredStyle: .alert)
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
        }else {
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
