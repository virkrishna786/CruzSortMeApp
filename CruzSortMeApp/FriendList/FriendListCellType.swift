//
//  FriendListCellType.swift
//  CruzSortMeApp
//
//  Created by Admin media on 1/13/17.
//  Copyright © 2017 Gopal Gupta. All rights reserved.
//

import UIKit

class FriendListCellType: UITableViewCell {

    @IBOutlet weak var friendNameLabel: UILabel!
    @IBAction func blockButtonAction(_ sender: UIButton) {
    }
    @IBOutlet weak var blockButton: UIButton!
  
    @IBOutlet weak var friendProfileImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
