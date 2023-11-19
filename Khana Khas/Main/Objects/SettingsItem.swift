//
//  SettingsItem.swift
//  Khana Khas
//
//  Created by Preet Jagani on 19/11/23.
//

import UIKit

import DifferenceKit

class SettingsItem: NSObject, Differentiable {
    
    let name: String
    let selected: Bool
    
    init(name: String, selected: Bool) {
        self.name = name
        self.selected = selected
    }
    
    var differenceIdentifier: String {
        return name
    }
    
    func isContentEqual(to source: SettingsItem) -> Bool {
        return self.name == source.name && self.selected == source.selected
    }
}
