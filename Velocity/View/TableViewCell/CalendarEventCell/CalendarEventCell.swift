//
//  CalendarEventCell.swift
//  Velocity
//
//  Created by Vishal Gohel on 07/03/19.
//

import UIKit
import  SDWebImage
class CalendarEventCell: UITableViewCell {
    @IBOutlet weak var stackMainContainer: UIStackView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func ConfigureCell(_ model: CalendarEvents) {
        lblTitle.text = model.title
        lblDetail.text = "\(model.startTime) to \(model.endTime)"
    }

}

class CalendarEventImageCell: UITableViewCell {
    
    @IBOutlet weak var imgEventPoster: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func ConfigureCell(_ model: CalendarEvents) {
        if model.offer.count > 0 {
            let urlString = model.offer.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            guard let url = URL(string: urlString!) else {
                imgEventPoster.image = UIImage(named: "slide")
                return
            }
            self.imgEventPoster.sd_setImage(with: url, placeholderImage: nil, options: SDWebImageOptions.refreshCached) { (image, error, type, imgURL) in
                if image == nil {
                    
                } else {
                    
                }
            }
        } else {
            imgEventPoster.image = UIImage(named: "slide")
        }
        imgEventPoster.layer.cornerRadius = 10
        imgEventPoster.layer.masksToBounds = true
    }
    
    func ConfigureImageCell(_ model: [String:Any]) {
        
        if let strImage = model["image"] as? String,strImage != ""{
            let urlString = strImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            guard let url = URL(string: urlString!) else {
                imgEventPoster.image = UIImage(named: "slide")
                return
            }
            self.imgEventPoster.sd_setImage(with: url, placeholderImage: nil, options: SDWebImageOptions.refreshCached) { (image, error, type, imgURL) in
                if image == nil {
                    
                } else {
                    
                }
            }
        }else{
            imgEventPoster.image = UIImage(named: "slide")
        }
        
        
        imgEventPoster.layer.cornerRadius = 10
        imgEventPoster.layer.masksToBounds = true
    }
    
    
}
