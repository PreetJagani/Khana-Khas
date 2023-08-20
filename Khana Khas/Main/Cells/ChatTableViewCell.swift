//
//  ChatTableViewCell.swift
//  Khana Khas
//
//  Created by Preet Jagani on 20/08/23.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var top: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.top.constant = 20
        self.alpha = 0.3
    }
    
    func animateFromBottom(completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .transitionCurlDown, animations: {
            self.top.constant = 4
            self.alpha = 1
            self.layoutIfNeeded()
        }, completion: completion)
        
    }
    
}
