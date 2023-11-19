//
//  PrefrenceManager.swift
//  Khana Khas
//
//  Created by Preet Jagani on 29/07/23.
//

import UIKit

class PreferenceManager: NSObject {
    
    static let shared = PreferenceManager()
    
    let userDefault : UserDefaults?
    
    private override init() {
        userDefault = UserDefaults()
        super.init()
        
        self.ensure(value: PreferredTasteType.REGULAR.rawValue, key: PreferenceManager.PREF_KEY_PREFERRED_TEST)
        self.ensure(value: FoodType.Indian.rawValue, key: PreferenceManager.PREF_KEY_COOKING_STYLE)
    }
    
    func set(bool: Bool, key: String) {
        self.userDefault?.setValue(bool, forKey: key)
    }
    
    func getBool(forKey key: String) -> Bool {
        if let val = self.userDefault?.value(forKey: key) as? Bool {
            return val
        } else {
            return false
        }
    }
    
    func set(string: String, key: String) {
        self.userDefault?.setValue(string, forKey: key)
    }
    
    func getString(forKey key: String) -> String? {
        if let val = self.userDefault?.value(forKey: key) as? String {
            return val
        } else {
            return nil
        }
    }
    
    func ensure(value: String, key: String) {
        guard self.getString(forKey: key) == nil else {
            return
        }
        self.set(string: value, key: key)
    }
}

// constants
extension PreferenceManager {
    
    static let PREF_KEY_ONBOARD_COMPLETE : String = "completeOnboard"
    static let PREF_KEY_PREFERRED_TEST : String = "preferredTest"
    static let PREF_KEY_COOKING_STYLE : String = "cookingStyle"
    
}
