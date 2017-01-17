//
//  FriendDetailCellType.swift
//  CruzSortMeApp
//
//  Created by Admin media on 1/16/17.
//  Copyright © 2017 Gopal Gupta. All rights reserved.
//

import UIKit

class FriendDetailCellType: UITableViewCell {

    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var friendDetailEventIdString: UILabel!
    @IBOutlet weak var friendEventRatingButton: UIButton!
    @IBOutlet weak var friendEventReviewButton: UIButton!
    @IBOutlet weak var friendEventTimeLabel: UILabel!
    @IBOutlet weak var friendEventDetail: UILabel!
    @IBOutlet weak var freindEventImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
