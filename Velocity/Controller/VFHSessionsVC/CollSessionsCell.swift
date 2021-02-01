//
//  CollSessionsCell.swift
//  Velocity
//
//  Created by Vishal Gohel on 18/04/19.
//

import UIKit
import SDWebImage
class CollSessionsCell: UICollectionViewCell {
    @IBOutlet weak var imgPoster: UIImageView!
    @IBOutlet weak var imgTransparent: UIImageView!
    @IBOutlet weak var btnTitle: UIButton!
    @IBOutlet var titleLabel: UILabel!

    func configureCell(_ model: Category) {
        if model.imageURL.count > 0 {
            let urlString = model.imageURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            guard let url = URL(string: urlString!) else {
                imgPoster.image = UIImage(named: "get-strong")
                return
            }
            self.imgPoster.sd_setImage(with: url, placeholderImage: nil, options: SDWebImageOptions.refreshCached) { (image, error, type, imgURL) in
                if image == nil {
                    
                } else {
                    
                }
            }
        } else {
            imgPoster.image = UIImage(named: "get-strong")
        }
     //   btnTitle.setTitle("\(model.title)", for: .normal)
        btnTitle.setTitle("", for: .normal)
    }
}
