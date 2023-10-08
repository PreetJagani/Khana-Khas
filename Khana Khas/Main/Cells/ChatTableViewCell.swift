//
//  ChatTableViewCell.swift
//  Khana Khas
//
//  Created by Preet Jagani on 20/08/23.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var top: NSLayoutConstraint!
    @IBInspectable var animateOnlyAlpha: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        
        if !animateOnlyAlpha {
            self.top.constant = 20
        }
        self.contentView.alpha = 0.3
    }
    
    func animateFromBottom(completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .transitionCurlDown, animations: {
            self.contentView.alpha = 1
            if !self.animateOnlyAlpha {
                self.top.constant = 4
                self.layoutIfNeeded()
            }
        }, completion: completion)
        
    }
    
}
