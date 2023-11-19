//
//  PrefrenceManager.swift
//  Khana Khas
//
//  Created by Preet Jagani on 29/07/23.
//

import UIKit

class PrefrenceManager: NSObject {
    
    static let shared = PrefrenceManager()
    
    let userDefault : UserDefaults?
    
    private override init() {
        userDefault = UserDefaults()
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
}

// constants
extension PrefrenceManager {
    
    static let PREF_KEY_ONBOARD_COMPLETE : String = "completeOnboard"
    static let PREF_KEY_PREFERRED_TEST : String = "preferredTest"
    static let PREF_KEY_COOKING_STYLE : String = "cookingStyle"
    
}
