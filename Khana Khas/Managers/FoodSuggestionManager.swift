//
//  FoodSuggetionManager.swift
//  Khana Khas
//
//  Created by Preet Jagani on 20/08/23.
//

import UIKit
import DifferenceKit

enum IngredientType: Int {
    case All = 0
    case Ingredients = 1
    case Vegetable = 2
    case Fruit = 3
}

class Ingredient: Hashable, Differentiable {
    
    let name : String
    let type : IngredientType
    
    init(name: String, type: IngredientType) {
        self.name = name
        self.type = type
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.name)
    }
    
    static func == (lhs: Ingredient, rhs: Ingredient) -> Bool {
        return lhs.name == rhs.name
    }
}

class IngredientSection: DifferentiableSection {
    
    typealias DifferenceIdentifier = String
    
    typealias Collection = [Ingredient]

    var elements: [Ingredient] {
        return items
    }
    
    var differenceIdentifier: String {
        get {
            return self.header
        }
    }
    
    func isContentEqual(to source: IngredientSection) -> Bool {
        return self.items.isContentEqual(to: source.items)
    }

    required init<C: Swift.Collection>(source: IngredientSection, elements: C) where C.Element == Ingredient {
        self.header = source.header
        self.items = Array(elements)
    }

    let header: String
    var items: [Ingredient]

    init(header: String, items: [Ingredient]) {
        self.header = header
        self.items = items
    }
}

class IngredientData {
    let sections: [IngredientSection]
    let sectionIndex: [String]
    
    init(sections: [IngredientSection], sectionIndex: [String]) {
        self.sections = sections
        self.sectionIndex = sectionIndex
    }
}

class FoodSuggestionManager: NSObject {
    
    static let shared = FoodSuggestionManager()
    
    private override init() {
        
    }
    
    func suggestFood(promt: String, completion: @escaping (String) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
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
    
    func ingredientsSection(searchString: String, type: IngredientType) -> IngredientData {
        
        var sections: [IngredientSection] = []
        
        var sectionMap : [String : IngredientSection] = [:]
        for food in FoodSuggestionManager.ingredientsList {
            if (type == .All || food.type == type), food.name.hasPrefix(searchString) {
                let header = food.name.first?.uppercased() ?? "A"
                if let section = sectionMap[header] {
                    section.items.append(food)
                } else {
                    let section = IngredientSection(header: header, items: [food])
                    sectionMap[header] = section
                    sections.append(section)
                }
            }
        }
        return IngredientData(sections: sections, sectionIndex: sectionMap.keys.sorted())
    }
}

// const
extension FoodSuggestionManager {
    
    static let ingredientsTypes: [String] = [
        "All", "Ingredients", "Vegetable", "Fruit"
    ]
    
    static let ingredientsList: [Ingredient] = [
        Ingredient(name: "Agave nectar", type: .Ingredients),
        Ingredient(name: "Almond flour", type: .Ingredients),
        Ingredient(name: "Apple cider vinegar", type: .Ingredients),
        Ingredient(name: "Apples", type: .Fruit),
        Ingredient(name: "Apricots", type: .Fruit),
        Ingredient(name: "Artichokes", type: .Vegetable),
        Ingredient(name: "Asparagus", type: .Vegetable),
        Ingredient(name: "Avocado", type: .Fruit),
        Ingredient(name: "Balsamic glaze", type: .Ingredients),
        Ingredient(name: "Basil", type: .Vegetable),
        Ingredient(name: "Beets", type: .Vegetable),
        Ingredient(name: "Bell peppers", type: .Vegetable),
        Ingredient(name: "Berries (raspberries, blackberries, etc.)", type: .Fruit),
        Ingredient(name: "Blackberries", type: .Fruit),
        Ingredient(name: "Blueberries", type: .Fruit),
        Ingredient(name: "Bread crumbs", type: .Ingredients),
        Ingredient(name: "Brussels sprouts", type: .Vegetable),
        Ingredient(name: "Butter", type: .Ingredients),
        Ingredient(name: "Cabbage", type: .Vegetable),
        Ingredient(name: "Carrots", type: .Vegetable),
        Ingredient(name: "Cauliflower", type: .Vegetable),
        Ingredient(name: "Celery", type: .Vegetable),
        Ingredient(name: "Cereal (cornflakes, bran flakes, etc.)", type: .Ingredients),
        Ingredient(name: "Cheese (cheddar, mozzarella, cream cheese, etc.)", type: .Ingredients),
        Ingredient(name: "Cherries", type: .Fruit),
        Ingredient(name: "Chili powder", type: .Ingredients),
        Ingredient(name: "Canned beans (black, kidney, etc.)", type: .Ingredients),
        Ingredient(name: "Canned corn", type: .Ingredients),
        Ingredient(name: "Canned fruits", type: .Ingredients),
        Ingredient(name: "Canned tomatoes (sauce, paste)", type: .Ingredients),
        Ingredient(name: "Canned vegetables", type: .Ingredients),
        Ingredient(name: "Coconut milk", type: .Ingredients),
        Ingredient(name: "Coconut oil", type: .Ingredients),
        Ingredient(name: "Cornmeal", type: .Ingredients),
        Ingredient(name: "Cornstarch", type: .Ingredients),
        Ingredient(name: "Cucumbers", type: .Vegetable),
        Ingredient(name: "Cumin", type: .Ingredients),
        Ingredient(name: "Dijon mustard", type: .Ingredients),
        Ingredient(name: "Eggs", type: .Ingredients),
        Ingredient(name: "Fish sauce", type: .Ingredients),
        Ingredient(name: "Figs", type: .Fruit),
        Ingredient(name: "Garlic", type: .Ingredients),
        Ingredient(name: "Garlic powder", type: .Ingredients),
        Ingredient(name: "Grapes", type: .Fruit),
        Ingredient(name: "Green beans", type: .Vegetable),
        Ingredient(name: "Guava", type: .Fruit),
        Ingredient(name: "Ghee", type: .Ingredients),
        Ingredient(name: "Heavy cream", type: .Ingredients),
        Ingredient(name: "Hoisin sauce", type: .Ingredients),
        Ingredient(name: "Honey", type: .Ingredients),
        Ingredient(name: "Jam or jelly", type: .Ingredients),
        Ingredient(name: "Kiwi", type: .Fruit),
        Ingredient(name: "Lemons", type: .Fruit),
        Ingredient(name: "Lettuce", type: .Vegetable),
        Ingredient(name: "Limes", type: .Fruit),
        Ingredient(name: "Mangoes", type: .Fruit),
        Ingredient(name: "Maple syrup", type: .Ingredients),
        Ingredient(name: "Mayonnaise", type: .Ingredients),
        Ingredient(name: "Milk (whole, skim, almond, soy, etc.)", type: .Ingredients),
        Ingredient(name: "Miso paste", type: .Ingredients),
        Ingredient(name: "Molasses", type: .Ingredients),
        Ingredient(name: "Mushrooms", type: .Vegetable),
        Ingredient(name: "Mustard", type: .Ingredients),
        Ingredient(name: "Nutella", type: .Ingredients),
        Ingredient(name: "Olive oil", type: .Ingredients),
        Ingredient(name: "Onions", type: .Vegetable),
        Ingredient(name: "Oregano", type: .Ingredients),
        Ingredient(name: "Papaya", type: .Fruit),
        Ingredient(name: "Paprika", type: .Ingredients),
        Ingredient(name: "Peaches", type: .Fruit),
        Ingredient(name: "Pears", type: .Fruit),
        Ingredient(name: "Peas", type: .Vegetable),
        Ingredient(name: "Pineapple", type: .Fruit),
        Ingredient(name: "Plums", type: .Fruit),
        Ingredient(name: "Potatoes", type: .Vegetable),
        Ingredient(name: "Quinoa", type: .Ingredients),
        Ingredient(name: "Radishes", type: .Vegetable),
        Ingredient(name: "Raspberries", type: .Fruit),
        Ingredient(name: "Red wine vinegar", type: .Ingredients),
        Ingredient(name: "Rice (white, brown, jasmine, basmati, etc.)", type: .Ingredients),
        Ingredient(name: "Rolled oats", type: .Ingredients),
        Ingredient(name: "Rosemary", type: .Ingredients),
        Ingredient(name: "Sour cream", type: .Ingredients),
        Ingredient(name: "Spinach", type: .Vegetable),
        Ingredient(name: "Strawberries", type: .Fruit),
        Ingredient(name: "Sugar (granulated, brown, powdered)", type: .Ingredients),
        Ingredient(name: "Sweet potatoes", type: .Vegetable),
        Ingredient(name: "Tahini", type: .Ingredients),
        Ingredient(name: "Thyme", type: .Ingredients),
        Ingredient(name: "Tomatoes", type: .Vegetable),
        Ingredient(name: "Tortillas", type: .Ingredients),
        Ingredient(name: "Vanilla extract", type: .Ingredients),
        Ingredient(name: "Vinegar (balsamic, white wine, etc.)", type: .Ingredients),
        Ingredient(name: "Watermelon", type: .Fruit),
        Ingredient(name: "White wine", type: .Ingredients),
        Ingredient(name: "Worcestershire sauce", type: .Ingredients),
        Ingredient(name: "Yogurt (Greek, regular)", type: .Ingredients),
        Ingredient(name: "Zucchini", type: .Vegetable)
    ]
}
