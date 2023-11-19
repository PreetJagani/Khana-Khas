//
//  SettingsItem.swift
//  Khana Khas
//
//  Created by Preet Jagani on 19/11/23.
//

import UIKit

import DifferenceKit

class SettingsItem: NSObject {
    
    let name: String
    let selected: Bool
    
    init(name: String, selected: Bool) {
        self.name = name
        self.selected = selected
    }
}

class SettingsSectionItem: NSObject {
    
    let name: String
    let items: [SettingsItem]
    
    init(name: String, items: [SettingsItem]) {
        self.name = name
        self.items = items
    }
}
