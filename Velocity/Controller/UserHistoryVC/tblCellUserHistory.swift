//
//  tblCellUserHistory.swift
//  Velocity
//
//  Created by Hexagon on 11/11/19.
//

import UIKit

class tblCellUserHistory: UITableViewCell {

    @IBOutlet weak var lblDate_Time: UILabel!
    @IBOutlet weak var lblBenchPress: UILabel!
    @IBOutlet weak var lblBackSquat: UILabel!
    @IBOutlet weak var lblDeadLift: UILabel!
    @IBOutlet weak var lbl500m: UILabel!
    @IBOutlet weak var lblHeight: UILabel!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var lblTimeTrial: UILabel!
    @IBOutlet weak var lblFitnessName: UILabel!
    @IBOutlet weak var lblMaxBridge: UILabel!
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
