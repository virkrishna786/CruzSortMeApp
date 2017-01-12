//
//  ReviewTableViewCell.swift
//  CruzSortMeApp
//
//  Created by Admin media on 1/11/17.
//  Copyright © 2017 Gopal Gupta. All rights reserved.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var reviewDetailLabel: UILabel!
    @IBOutlet weak var reviewCustomView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
