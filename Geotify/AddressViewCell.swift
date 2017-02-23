//
//  AddressViewCell.swift
//  Geotify
//
//  Created by Clay Sullivan on 2/2/17.
//  Copyright © 2017 Clay Sullivan. All rights reserved.
//

import UIKit

class AddressViewCell: UITableViewCell {

  
  @IBOutlet weak var labelOutlet: UILabel!
  @IBOutlet weak var lineOneOutlet: UILabel!
  @IBOutlet weak var lineTwoOutlet: UILabel!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
