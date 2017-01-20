//
//  GroupDetailCellType.swift
//  CruzSortMeApp
//
//  Created by Admin media on 1/20/17.
//  Copyright © 2017 Gopal Gupta. All rights reserved.
//

import UIKit

class GroupDetailCellType: UITableViewCell {

    @IBOutlet weak var groupFriendNameLabel: UILabel!
    @IBOutlet weak var groupFriendImageView: UIImageView!
    {
        didSet{
            groupFriendImageView.layer.borderWidth = 1
            groupFriendImageView.layer.masksToBounds = false
            groupFriendImageView.layer.borderColor = UIColor.white.cgColor
            groupFriendImageView.layer.cornerRadius = groupFriendImageView.frame.height/2
            groupFriendImageView.clipsToBounds = true
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
