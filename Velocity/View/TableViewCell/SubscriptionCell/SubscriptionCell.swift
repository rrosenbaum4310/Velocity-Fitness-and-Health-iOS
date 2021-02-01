//
//  SubscriptionCell.swift
//  Velocity
//
//  Created by Vishal Gohel on 20/02/19.
//

import UIKit

class SubscriptionCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var imgRadio: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(model: Membership) {
        
        lblTitle.text = "\(model.title) \(model.days)"
        lblDetail.text = model.price
        
        if model.isSelected {
            imgRadio.image = UIImage(named: "radio-on-button")
        } else {
            imgRadio.image = UIImage(named: "radio-off-button")
        }
        
        
    }
    

}
