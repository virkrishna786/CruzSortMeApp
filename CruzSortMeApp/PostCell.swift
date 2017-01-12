//
//  PostCell.swift
//  CruzSortMeApp
//
//  Created by Admin media on 1/10/17.
//  Copyright © 2017 Gopal Gupta. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var ratingButton: UIButton!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var customView: UIView!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
