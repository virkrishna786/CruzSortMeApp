//
//  WhoseAroundPeopleCell.swift
//  CruzSortMeApp
//
//  Created by Admin media on 1/27/17.
//  Copyright © 2017 Gopal Gupta. All rights reserved.
//

import UIKit

class WhoseAroundPeopleCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!

    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
