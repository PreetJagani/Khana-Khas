//
//  ChatLoadingTableViewCell.swift
//  Khana Khas
//
//  Created by Preet Jagani on 20/08/23.
//

import UIKit

class ChatLoadingTableViewCell: UITableViewCell {

    @IBOutlet weak var one: UIView!
    @IBOutlet weak var two: UIView!
    @IBOutlet weak var three: UIView!
    
    var views : [UIView] = []
    var curr = -1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.one.alpha = 0.5
        self.two.alpha = 0.5
        self.three.alpha = 0.5
        
        self.views.append(self.one)
        self.views.append(self.two)
        self.views.append(self.three)
        self.animate()
    }
    
    func animate() {
        curr = (curr + 1) % self.views.count;
        let view = self.views[curr]
        self.animate(view: view)
    }
    
    func animate(view: UIView) {
        let duration = TimeInterval(1.0/3)
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseIn], animations: {
            view.alpha = 0.9
        }) { _ in
            self.animate()
            UIView.animate(withDuration: 2 * duration, delay: 0, options: [.curveEaseOut], animations: {
                view.alpha = 0.5
            }) { _ in

            }
        }
    }

}
