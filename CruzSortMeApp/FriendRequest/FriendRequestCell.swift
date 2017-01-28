//
//  FriendRequestCell.swift
//  CruzSortMeApp
//
//  Created by Admin media on 1/28/17.
//  Copyright © 2017 Gopal Gupta. All rights reserved.
//

import UIKit

class FriendRequestCell: UITableViewCell {

    @IBAction func declineButtonAction(_ sender: UIButton) {
    }
    @IBAction func addButtonAction(_ sender: UIButton) {
    }
    @IBOutlet weak var friednRequestIdLabel: UILabel!
    @IBOutlet weak var declineButton: UIButton!{
        didSet{
            self.declineButton.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var addButton: UIButton!{
        didSet{
            self.addButton.layer.cornerRadius = 5
        }
    }

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
