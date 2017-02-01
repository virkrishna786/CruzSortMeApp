//
//  RIghtBubbleCell.swift
//  Visit
//
//  Created by Krishna on 06/09/16.
//  Copyright © 2016 Chetan Anand. All rights reserved.
//

import UIKit

class RIghtBubbleCell: UICollectionViewCell {
    
    @IBOutlet weak var rightCustomView: UIView!
    {
        didSet{
        rightCustomView.layer.masksToBounds = true
            rightCustomView.layer.shadowOpacity = 0.8
            rightCustomView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            rightCustomView.layer.shadowRadius = 1.8
            rightCustomView.layer.shadowColor = UIColor.gray.cgColor
            rightCustomView.layer.cornerRadius = 4.0
            rightCustomView.sizeToFit()
            rightCustomView.layoutIfNeeded()
        }
    }
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var rightImageView: UIImageView!
    {
        didSet {
            
            rightImageView.layer.borderWidth = 1
            rightImageView.layer.masksToBounds = false
            rightImageView.layer.borderColor = UIColor.white.cgColor
            rightImageView.layer.cornerRadius = rightImageView.frame.height/2
            rightImageView.clipsToBounds = true
            

        }
        
    }
    @IBOutlet weak var chatRightLabel: UILabel! {
        
        didSet {
            
//            chatRightLabel.layer.cornerRadius = 5.0
//            chatRightLabel.layer.borderColor = UIColor.grayColor().CGColor
//            chatRightLabel.layer.borderWidth = 0.4
//            chatRightLabel.layer.shadowColor = UIColor.whiteColor().CGColor
//            chatRightLabel.layer.shadowOpacity = 0.7
//            chatRightLabel.layer.shadowRadius = 5
//            chatRightLabel.layer.shadowOffset = CGSize(width: 3, height: 3)
            chatRightLabel.layer.masksToBounds = true
            chatRightLabel .sizeToFit()
            
            
        }
    }
}
