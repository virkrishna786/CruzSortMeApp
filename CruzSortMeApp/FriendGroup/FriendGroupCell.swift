
//
//  FriendGroupCell.swift
//  CruzSortMeApp
//
//  Created by Admin media on 1/17/17.
//  Copyright © 2017 Gopal Gupta. All rights reserved.
//

import UIKit

class FriendGroupCell: UITableViewCell {

    @IBOutlet weak var numberOfMemberLabel: UILabel!
    @IBOutlet weak var groupNamelabel: UILabel!
    @IBOutlet weak var friendGroupImageView: UIImageView!{
        didSet{
            friendGroupImageView.layer.borderWidth = 1
            friendGroupImageView.layer.masksToBounds = false
            friendGroupImageView.layer.borderColor = UIColor.white.cgColor
            friendGroupImageView.layer.cornerRadius = friendGroupImageView.frame.height/2
            friendGroupImageView.clipsToBounds = true
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
