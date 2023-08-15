//
//  ChatTableViewCell.swift
//  Khana Khas
//
//  Created by Preet Jagani on 30/07/23.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var leading: NSLayoutConstraint!
    @IBOutlet weak var top: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.parentView.layer.cornerRadius = 16
        self.parentView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner];
        
        self.leading.constant = -8
        self.top.constant = 20
        self.alpha = 0.3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func animateFromBottomLeft(completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .transitionCurlDown, animations: {
            self.leading.constant = 16
            self.top.constant = 4
            self.alpha = 1
            self.layoutIfNeeded()
        }, completion: completion)
        
    }
}
