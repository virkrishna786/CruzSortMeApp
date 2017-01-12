//
//  EventDetailCell.swift
//  CruzSortMeApp
//
//  Created by Admin media on 1/11/17.
//  Copyright © 2017 Gopal Gupta. All rights reserved.
//

import UIKit

class EventDetailCell: UITableViewCell {

    @IBOutlet weak var ratingButton: UIButton!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var addresslabel: UILabel!
    @IBOutlet weak var eventDetailLabel: UILabel!
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
