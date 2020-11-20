//
//  RecipeSearchTableViewCell.swift
//  Assignment3
//
//  Created by admin on 2020/11/15.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class RecipeSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var searchImage: UIImageView!
    @IBOutlet weak var searchTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
