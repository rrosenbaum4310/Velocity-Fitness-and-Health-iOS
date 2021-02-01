//
//  NoteDetailCell.swift
//  Velocity
//
//  Created by Vishal Gohel on 19/02/19.
//

import UIKit

class NoteDetailCell: UITableViewCell {
    @IBOutlet weak var txtNotes: VFHTextView!
    @IBOutlet weak var imgSymbol: UIImageView!
    @IBOutlet weak var stackSymbolContainer: UIStackView!
    @IBOutlet weak var stackContainer: UIStackView!
    @IBOutlet weak var nslcTxtNotesHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func ConfigureCell(text: String, isEditIcon: Bool) {
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: "OpenSans", size: 12) ?? UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.gray]
        let attributed = NSMutableAttributedString(string: text, attributes: attributes)
        
        
        if isEditIcon {
            
            if let img = UIImage(named: "edit-note") {
                let textAttachedment = NSTextAttachment()
                textAttachedment.image = img
                let attrStringWithImage = NSAttributedString(attachment: textAttachedment)
                attributed.append(attrStringWithImage)
            }
        }
        
        txtNotes.attributedText = attributed
        txtNotes.setNeedsDisplay()
        let height = txtNotes.contentSize.height
        nslcTxtNotesHeight.constant = height
        txtNotes.isScrollEnabled = false
        
    }
    

}
