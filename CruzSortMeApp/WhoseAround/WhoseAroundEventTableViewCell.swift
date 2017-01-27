//
//  WhoseAroundEventTableViewCell.swift
//  CruzSortMeApp
//
//  Created by Admin media on 1/27/17.
//  Copyright © 2017 Gopal Gupta. All rights reserved.
//

import UIKit

class WhoseAroundEventTableViewCell: UITableViewCell {

    @IBOutlet weak var eventDistanceLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
