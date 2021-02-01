//
//  NotesHeaderCell.swift
//  Velocity
//
//  Created by Vishal Gohel on 03/04/19.
//

import UIKit

class NotesHeaderCell: UITableViewCell {

    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
