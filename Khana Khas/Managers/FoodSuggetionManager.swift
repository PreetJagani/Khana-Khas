//
//  FoodSuggetionManager.swift
//  Khana Khas
//
//  Created by Preet Jagani on 20/08/23.
//

import UIKit

class FoodSuggetionManager: NSObject {
    
    static let shared = FoodSuggetionManager()
    
    private override init() {
        
    }
    
    func suggestFood(promt: String, completion: @escaping (String) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            completion("""
                        Dal Dhokli:
                        Dal Dhokli is a comforting one-pot dish that combines soft wheat flour dumplings (dhokli) with a spiced lentil soup (dal). The dumplings are simmered in the dal until they're cooked through, creating a hearty and flavorful meal.
                        Ringan Ravaiya:
                        Ringan Ravaiya, also known as Baingan Bharta in some regions, is a roasted eggplant dish. The eggplant is roasted, mashed, and then cooked with spices, tomatoes, and sometimes peas. It's usually enjoyed with roti or rice.
                        Surti Undhiyu:
                        Surti Undhiyu is a popular winter dish that consists of mixed vegetables, fenugreek dumplings, and spices. It's traditionally cooked in an earthen pot and has a unique blend of flavors due to the use of special spices and cooking techniques.
                        """)
        }
    }
}
