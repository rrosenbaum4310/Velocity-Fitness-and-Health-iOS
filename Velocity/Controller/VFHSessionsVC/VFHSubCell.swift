//
//  VFHSubCell.swift
//  Velocity
//
//  Created by prominere on 13/01/20.
//

import UIKit

class VFHSubCell: UITableViewCell {

    @IBOutlet weak var imgPoster: UIImageView!
       @IBOutlet weak var imgTransparent: UIImageView!
       @IBOutlet weak var btnTitle: UIButton!
       @IBOutlet var titleLabel: UILabel!
    @IBOutlet var borderView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
