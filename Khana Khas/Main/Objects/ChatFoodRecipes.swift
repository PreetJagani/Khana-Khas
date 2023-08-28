//
//  FoodRecipe.swift
//  Khana Khas
//
//  Created by Preet Jagani on 28/08/23.
//

import UIKit

class Recipe: NSObject {
    
    let title: String
    let des: String
    
    init(title: String, des: String) {
        self.title = title
        self.des = des
    }
}

class ChatFoodRecipes: ChatItem {
    let recipes: [Recipe]
    
    init(id: Int, text: String, recipes: [Recipe]) {
        self.recipes = recipes
        super.init(id: id, text: text)
    }

}
