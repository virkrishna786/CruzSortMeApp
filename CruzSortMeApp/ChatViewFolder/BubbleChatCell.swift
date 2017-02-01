//
//  BubbleChatCell.swift
//  Visit
//
//  Created by Krishna on 26/08/16.
//  Copyright © 2016 Chetan Anand. All rights reserved.
//

import UIKit

class BubbleChatCell: UICollectionViewCell {
    
    @IBOutlet weak var bubbleView: UIView!{
        didSet {
            let frame = bubbleView.frame
            let customBubbleView = UIView()
            customBubbleView.frame = frame
            customBubbleView.layer.cornerRadius = 5.0
            customBubbleView.layer.masksToBounds = true
            bubbleView.layer.shadowOpacity = 0.7
            bubbleView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            bubbleView.layer.shadowRadius = 1.5
            bubbleView.layer.shadowColor = UIColor.gray.cgColor
            bubbleView.layer.cornerRadius = 4.0

            bubbleView.addSubview(customBubbleView)
            bubbleView.sizeToFit()
            bubbleView.layoutIfNeeded()
        }
    }
    @IBOutlet weak var timeLable: UILabel!
    @IBOutlet weak var leftBubbleChatLable: UILabel! {
        
        didSet {
            
                       
//            let frame = leftBubbleChatLable.frame
//            let customBubbleView = UIView()
//            customBubbleView.frame = frame
//            customBubbleView.layer.cornerRadius = 5.0
//            customBubbleView.layer.masksToBounds = true
//            
//            leftBubbleChatLable.layer.cornerRadius = 5.0
//            leftBubbleChatLable.layer.masksToBounds = true
//            leftBubbleChatLable.layer.borderColor = UIColor.grayColor().CGColor
//            leftBubbleChatLable.layer.borderWidth = 0.1
//            leftBubbleChatLable.layer.shadowOpacity = 0.2
//            //            leftBubbleChatLable.layer.shadowColor = UIColor.grayColor().CGColor
//            leftBubbleChatLable.layer.shadowOpacity = 1.0
//            leftBubbleChatLable.layer.shadowRadius = 1.0
//            leftBubbleChatLable.layer.shadowOffset = CGSizeMake(3.0, 3.0)
//            leftBubbleChatLable.addSubview(customBubbleView)
//            // leftBubbleChatLable.layer.shadowPath = UIBezierPath(rect: leftBubbleChatLable.bounds).CGPath
            leftBubbleChatLable.sizeToFit()
//            leftBubbleChatLable.layoutIfNeeded()

        }
    }

    @IBOutlet weak var leftImageView: UIImageView! {
        
        didSet {
            
            leftImageView.layer.borderWidth = 1
            leftImageView.layer.masksToBounds = false
            leftImageView.layer.borderColor = UIColor.white.cgColor
            leftImageView.layer.cornerRadius = leftImageView.frame.height/2
            leftImageView.clipsToBounds = true
        }
    }
    
    
    
}
