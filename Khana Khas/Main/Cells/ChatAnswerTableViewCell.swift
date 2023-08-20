//
//  ChatTableViewCell.swift
//  Khana Khas
//
//  Created by Preet Jagani on 30/07/23.
//

import UIKit

class ChatAnswerTableViewCell: ChatTableViewCell {

    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var leading: NSLayoutConstraint!
    @IBOutlet weak var titlteLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.parentView.layer.cornerRadius = 16
        self.parentView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner];
    }
    
    func refresh(text: String) {
        self.titlteLable.text = text
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
