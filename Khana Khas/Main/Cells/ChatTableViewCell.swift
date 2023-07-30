//
//  ChatTableViewCell.swift
//  Khana Khas
//
//  Created by Preet Jagani on 30/07/23.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var parentView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.parentView.layer.cornerRadius = 16
        self.parentView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner];
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
