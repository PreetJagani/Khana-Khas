//
//  ChatRightTableViewCell.swift
//  Khana Khas
//
//  Created by Preet Jagani on 30/07/23.
//

import UIKit

class ChatQuetionTableViewCell: UITableViewCell {

    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.parentView.layer.cornerRadius = 16
        self.parentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner];
    }
    
    func refresh(text: String) {
        self.titleLabel.text = text
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
