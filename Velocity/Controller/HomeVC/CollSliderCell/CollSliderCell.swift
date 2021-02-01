//
//  CollSliderCell.swift
//  Velocity
//
//  Created by Vishal Gohel on 05/03/19.
//

import UIKit
import SDWebImage
class CollSliderCell: UICollectionViewCell {
    @IBOutlet weak var imgSlider: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    func configureCell(_ model: Banner) {
        if model.imageURL.count > 0 {
            let urlString = model.imageURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            guard let url = URL(string: urlString!) else {
                imgSlider.image = UIImage(named: "slide")
                return
            }
            self.imgSlider.sd_setImage(with: url, placeholderImage: nil, options: SDWebImageOptions.refreshCached) { (image, error, type, imgURL) in
                if image == nil {
                
                } else {
            
                }
            }
        } else {
            imgSlider.image = UIImage(named: "slide")
        }

    }
    
    func configureVideoCell(_ model: Video) {
        
        if model.title.count > 0 {
            self.lblTitle.text = model.title
        } else {
            self.lblTitle.text = ""
        }
        
        if model.thumbnail.count > 0 {
            let urlString = model.thumbnail.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            guard let url = URL(string: urlString!) else {
                imgSlider.image = UIImage(named: "slide")
                return
            }
            self.imgSlider.sd_setImage(with: url, placeholderImage: nil, options: SDWebImageOptions.refreshCached) { (image, error, type, imgURL) in
                if image == nil {
                    
                } else {
                    
                }
            }
        } else {
            imgSlider.image = UIImage(named: "slide")
        }
        
        
    }
    
}
