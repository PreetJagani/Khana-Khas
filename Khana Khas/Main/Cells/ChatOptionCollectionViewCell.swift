//
//  ChatOptionCollectionViewCell.swift
//  Khana Khas
//
//  Created by Preet Jagani on 15/08/23.
//

import UIKit

class ChatOptionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lable: UILabel!
    @IBOutlet weak var parent: UIView!
    
    var isOptionSelected = false

    override func awakeFromNib() {
        super.awakeFromNib()
        self.updateTheme()
    }
    
    private func updateTheme() {
        if self.isOptionSelected {
            self.parent.layer.backgroundColor = UIColor.systemGray2.cgColor
        } else {
            self.parent.layer.backgroundColor = UIColor.secondarySystemBackground.cgColor
        }
    }
    
    func update(text: String, selected: Bool) {
        self.isOptionSelected = selected
        self.lable.text = text
        self.updateTheme()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.updateTheme()
    }
}
