//
//  ImageUploadTableViewCell.swift
//  Assignment3
//
//  Created by admin on 2020/11/21.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class ImageUploadTableViewCell: UITableViewCell {

    @IBOutlet weak var possImage: UIImageView!
    @IBOutlet weak var cateImage: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var uploadImage: UIImageView!
    @IBOutlet weak var cateLabel: UILabel!
    @IBOutlet weak var possibilityLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
