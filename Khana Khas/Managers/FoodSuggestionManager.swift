//
//  FoodSuggetionManager.swift
//  Khana Khas
//
//  Created by Preet Jagani on 20/08/23.
//

import UIKit
import DifferenceKit

let url = "http://192.168.13.147:8000"
let suggestUrl = "\(url)/suggest"
let detailUrl = "\(url)/detail"

enum IngredientType: Int {
    case All = 0
    case Ingredients = 1
    case Vegetable = 2
    case Fruit = 3
}

class Ingredient: Hashable, Differentiable, CustomStringConvertible {
    
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
    
    var description: String {
        get {
            return self.name
        }
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
    private var recipeDetailCache: [String: [String: Any]] = [:]
    
    private override init() {
        
    }
    
    func suggestFood(foodTime: String, foodType: String, ingredients: String, completion: @escaping (Dictionary<String, Any>, Error?) -> Void) {
        if let url = URL(string: suggestUrl) {
            let session = URLSession.shared
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let jsonBody: [String: Any] = [
                "food_time": foodTime,
                "food_type": foodType,
                "ingredients": ingredients
            ]
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: jsonBody, options: [])
                request.httpBody = jsonData
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                print("Error creating JSON data: \(error)")
                return
            }
            
            let task = session.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                    completion([:], error)
                    return
                }
                
                if let data = data {
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("Response: \(jsonString)")
                        do {
                            if let json = try JSONSerialization.jsonObject(with: data) as? Dictionary<String, Any> {
                                completion(json, nil)
                            } else {
                                completion([:], error)                                
                            }
                        } catch let error {
                            completion([:], error)
                            print(error)
                        }
                    }
                }
            }
            task.resume()
        } else {
            completion([:], nil)
        }
    }
    
    func ingredientsSection(searchString: String, type: IngredientType) -> IngredientData {
        
        var sections: [IngredientSection] = []
        
        var sectionMap : [String : IngredientSection] = [:]
        for food in FoodSuggestionManager.sorted {
            if (type == .All || food.type == type), food.name.anyHasPrefix(searchString) {
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
    
    func recipeDetail(name: String, info: String, completion: @escaping ([String: Any]) -> Void) {
        if let detail = self.recipeDetailCache[name] {
            completion(detail)
            return
        }
        let post = ["recipe_name": name, "recipe_info": info]
        
        NetworkManager.shared.post(url: detailUrl, post: post) { json, error in
            do {
                if error == nil,
                   let res = json["res"] as? String,
                   let data = res.data(using: .utf8),
                   let detail = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    self.recipeDetailCache[name] = detail
                    completion(detail)
                } else {
                    completion([:])
                }
            } catch let error {
                print(error)
                completion([:])
            }
        }
    }
}

extension String {
    func anyHasPrefix(_ prefix: String) -> Bool {
        let words = self.split(separator: " ")
        for word in words {
            if word.lowercased().hasPrefix(prefix.lowercased()) {
                return true
            }
            if word.hasPrefix("("), word.lowercased().hasPrefix("(" + prefix.lowercased()) {
                return true
            }
        }
        return false
    }
}

// const
extension FoodSuggestionManager {
    
    static let ingredientsTypes: [String] = [
        "All", "Ingredients", "Vegetable", "Fruit"
    ]
    
    static let ingredientsList: [Ingredient] = [
        // A
        Ingredient(name: "Aloo (Potato)", type: .Vegetable),
        Ingredient(name: "Adrak (Ginger)", type: .Ingredients),
        Ingredient(name: "Amchur (Dried Mango Powder)", type: .Ingredients),
        Ingredient(name: "Ajwain (Carom Seeds)", type: .Ingredients),
        Ingredient(name: "Anardana (Pomegranate Seeds)", type: .Ingredients),
        Ingredient(name: "Aam (Mango)", type: .Fruit),
        Ingredient(name: "Amla (Indian Gooseberry)", type: .Fruit),
        Ingredient(name: "Atta (Whole Wheat Flour)", type: .Ingredients),
        Ingredient(name: "Arhar Dal (Split Pigeon Peas)", type: .Ingredients),
        Ingredient(name: "Almonds", type: .Ingredients),
        Ingredient(name: "Apples", type: .Fruit),
        Ingredient(name: "Apricots", type: .Fruit),
        Ingredient(name: "Avocado", type: .Fruit),
        Ingredient(name: "Asafoetida (Hing)", type: .Ingredients),
        Ingredient(name: "Almond Oil", type: .Ingredients),
        Ingredient(name: "Almond Milk", type: .Ingredients),
        Ingredient(name: "Allspice", type: .Ingredients),
        Ingredient(name: "Avocado Oil", type: .Ingredients),
        
        // B
        Ingredient(name: "Bananas", type: .Fruit),
        Ingredient(name: "Bell Peppers", type: .Vegetable),
        Ingredient(name: "Broccoli", type: .Vegetable),
        Ingredient(name: "Basmati Rice", type: .Ingredients),
        Ingredient(name: "Black Beans", type: .Ingredients),
        Ingredient(name: "Butter", type: .Ingredients),
        Ingredient(name: "Brinjal", type: .Vegetable),
        Ingredient(name: "Bread", type: .Ingredients),
        Ingredient(name: "Brown Sugar", type: .Ingredients),
        Ingredient(name: "Blueberries", type: .Fruit),
        Ingredient(name: "Black Pepper", type: .Ingredients),
        Ingredient(name: "Brussels Sprouts", type: .Vegetable),
        Ingredient(name: "Balsamic Vinegar", type: .Ingredients),
        Ingredient(name: "Brie Cheese", type: .Ingredients),
        Ingredient(name: "Balsamic Vinegar", type: .Ingredients),
        Ingredient(name: "Bread Crumbs", type: .Ingredients),
        Ingredient(name: "Buttermilk", type: .Ingredients),
        Ingredient(name: "Brown Rice", type: .Ingredients),
        Ingredient(name: "Brown Bread", type: .Ingredients),
        Ingredient(name: "Blackberries", type: .Fruit),
        Ingredient(name: "Bengal Gram (Chana Dal)", type: .Ingredients),
        Ingredient(name: "Biscuits", type: .Ingredients),
        
        // C
        Ingredient(name: "Cabbage", type: .Vegetable),
        Ingredient(name: "Carrots", type: .Vegetable),
        Ingredient(name: "Cauliflower", type: .Vegetable),
        Ingredient(name: "Coriander Seeds", type: .Ingredients),
        Ingredient(name: "Cumin Seeds", type: .Ingredients),
        Ingredient(name: "Cardamom", type: .Ingredients),
        Ingredient(name: "Cashews", type: .Ingredients),
        Ingredient(name: "Coconut Milk", type: .Ingredients),
        Ingredient(name: "Cheese", type: .Ingredients),
        Ingredient(name: "Cinnamon", type: .Ingredients),
        Ingredient(name: "Cloves", type: .Ingredients),
        Ingredient(name: "Cucumber", type: .Vegetable),
        Ingredient(name: "Cherries", type: .Fruit),
        Ingredient(name: "Cranberries", type: .Fruit),
        Ingredient(name: "Cream", type: .Ingredients),
        
        // D
        Ingredient(name: "Dates", type: .Fruit),
        Ingredient(name: "Dragon Fruit", type: .Fruit),
        Ingredient(name: "Dill", type: .Vegetable),
        Ingredient(name: "Daikon Radish", type: .Vegetable),
        Ingredient(name: "Dark Chocolate", type: .Ingredients),
        Ingredient(name: "Dried Cranberries", type: .Ingredients),
        
        // E
        Ingredient(name: "Eggplant", type: .Vegetable),
        
        // F
        Ingredient(name: "Fettuccine Pasta", type: .Ingredients),
        Ingredient(name: "Flour", type: .Ingredients),
        Ingredient(name: "French Fries", type: .Ingredients),
        Ingredient(name: "French Toast", type: .Ingredients),
        
        // G
        Ingredient(name: "Garbanzo Beans", type: .Ingredients),
        Ingredient(name: "Garlic", type: .Vegetable),
        Ingredient(name: "Garlic Powder", type: .Ingredients),
        Ingredient(name: "Garam Masala", type: .Ingredients),
        Ingredient(name: "Ghee", type: .Ingredients),
        Ingredient(name: "Ginger", type: .Ingredients),
        Ingredient(name: "Ginger Garlic Paste", type: .Ingredients),
        Ingredient(name: "Ginger Powder", type: .Ingredients),
        Ingredient(name: "Gorgonzola Cheese", type: .Ingredients),
        Ingredient(name: "Grapes", type: .Fruit),
        Ingredient(name: "Green Beans", type: .Vegetable),
        Ingredient(name: "Green Bell Pepper", type: .Vegetable),
        Ingredient(name: "Green Cardamom (Ilaayachee)", type: .Ingredients),
        Ingredient(name: "Green Chilies", type: .Vegetable),
        Ingredient(name: "Green Curry Paste", type: .Ingredients),
        Ingredient(name: "Green Onions", type: .Vegetable),
        Ingredient(name: "Green Peas", type: .Vegetable),
        Ingredient(name: "Guacamole", type: .Ingredients),
        Ingredient(name: "Guava", type: .Fruit),
        
        // H
        Ingredient(name: "Honey", type: .Ingredients),
        Ingredient(name: "Habanero Peppers", type: .Vegetable),
        Ingredient(name: "Hokkien Noodles", type: .Ingredients),
        Ingredient(name: "Hamburger Buns", type: .Ingredients),
        Ingredient(name: "Hemp Seeds", type: .Ingredients),
        Ingredient(name: "Hazelnut Butter", type: .Ingredients),
        Ingredient(name: "Hot Sauce", type: .Ingredients),
        
        // I
        Ingredient(name: "Iceberg Lettuce", type: .Vegetable),
        Ingredient(name: "Idli Rice", type: .Ingredients),
        Ingredient(name: "Instant Coffee", type: .Ingredients),
        Ingredient(name: "Indian Gooseberry (Amla)", type: .Fruit),
        Ingredient(name: "Indian Mustard Seeds", type: .Ingredients),
        Ingredient(name: "Italian Bread", type: .Ingredients),
        Ingredient(name: "Ice Cream", type: .Ingredients),
        Ingredient(name: "Indian Black Salt (Kala Namak)", type: .Ingredients),
        Ingredient(name: "Instant Oats", type: .Ingredients),
        Ingredient(name: "Indian Bay Leaves (Tej Patta)", type: .Ingredients),
        Ingredient(name: "Indian Five Spice (Panch Phoron)", type: .Ingredients),
        Ingredient(name: "Italian Pasta", type: .Ingredients),
        Ingredient(name: "Ice Cubes", type: .Ingredients),
        Ingredient(name: "Indian Bread (Roti)", type: .Ingredients),
        Ingredient(name: "Instant Pudding", type: .Ingredients),
        Ingredient(name: "Indian Cottage Cheese (Paneer)", type: .Ingredients),
        
        // J
        Ingredient(name: "Jackfruit", type: .Fruit),
        Ingredient(name: "Jalapeno Peppers", type: .Vegetable),
        Ingredient(name: "Jasmine Rice", type: .Ingredients),
        Ingredient(name: "Jackfruit Seeds", type: .Ingredients),
        Ingredient(name: "Jarlsberg Cheese", type: .Ingredients),
        Ingredient(name: "Java Plum (Jamun)", type: .Fruit),
        Ingredient(name: "Jasmine Tea", type: .Ingredients),
        
        // K
        Ingredient(name: "Ketchup", type: .Ingredients),
        Ingredient(name: "Kidney Beans (Rajma)", type: .Ingredients),
        Ingredient(name: "Kiwi", type: .Fruit),
        Ingredient(name: "Kohlrabi", type: .Vegetable),
        Ingredient(name: "Kalamata Olives", type: .Ingredients),
        Ingredient(name: "Kaleidoscope Cauliflower", type: .Vegetable),
        
        // L
        Ingredient(name: "Lettuce", type: .Vegetable),
        Ingredient(name: "Lemon", type: .Fruit),
        Ingredient(name: "Lime", type: .Fruit),
        Ingredient(name: "Lima Beans", type: .Ingredients),
        Ingredient(name: "Lobster", type: .Ingredients),
        Ingredient(name: "Lemon", type: .Ingredients),
        
        // M
        Ingredient(name: "Mango", type: .Fruit),
        Ingredient(name: "Mint", type: .Ingredients),
        Ingredient(name: "Mushrooms", type: .Vegetable),
        Ingredient(name: "Mustard Greens", type: .Vegetable),
        Ingredient(name: "Macadamia Nuts", type: .Ingredients),
        Ingredient(name: "Maple Syrup", type: .Ingredients),
        Ingredient(name: "Milk", type: .Ingredients),
        Ingredient(name: "Mozzarella Cheese", type: .Ingredients),
        Ingredient(name: "Mango Chutney", type: .Ingredients),
        Ingredient(name: "Mushroom Soup", type: .Ingredients),
        Ingredient(name: "Mustard Seeds", type: .Ingredients),
        Ingredient(name: "Macaroni", type: .Ingredients),
        Ingredient(name: "Margarine", type: .Ingredients),
        Ingredient(name: "Mixed Vegetables", type: .Vegetable),
        Ingredient(name: "Mango Slices", type: .Fruit),
        Ingredient(name: "Mushroom Gravy", type: .Ingredients),
        Ingredient(name: "Mustard Greens Salad", type: .Vegetable),
        Ingredient(name: "Mushroom Risotto", type: .Ingredients),
        Ingredient(name: "Mustard Dressing", type: .Ingredients),
        Ingredient(name: "Macaroni Salad", type: .Ingredients),
        Ingredient(name: "Margarita Mix", type: .Ingredients),
        Ingredient(name: "Mixed Berries", type: .Fruit),
        
        // N
        Ingredient(name: "Navy Beans", type: .Ingredients),
        Ingredient(name: "Noodles", type: .Ingredients),
        Ingredient(name: "Napa Cabbage", type: .Vegetable),
        Ingredient(name: "Noodle Soup", type: .Ingredients),
        Ingredient(name: "Nectarine Slices", type: .Fruit),
        Ingredient(name: "Nutmeg Spice", type: .Ingredients),
        Ingredient(name: "Navy Bean Stew", type: .Ingredients),
        Ingredient(name: "Nuts", type: .Ingredients),
        
        // O
        Ingredient(name: "Oats", type: .Ingredients),
        Ingredient(name: "Olive Oil", type: .Ingredients),
        Ingredient(name: "Onions", type: .Vegetable),
        Ingredient(name: "Oranges", type: .Fruit),
        Ingredient(name: "Oregano", type: .Ingredients),
        
        // P
        Ingredient(name: "Papaya", type: .Fruit),
        Ingredient(name: "Peanuts", type: .Ingredients),
        Ingredient(name: "Pears", type: .Fruit),
        Ingredient(name: "Peas", type: .Vegetable),
        Ingredient(name: "Penne Pasta", type: .Ingredients),
        Ingredient(name: "Pepperoni", type: .Ingredients),
        Ingredient(name: "Persimmons", type: .Fruit),
        Ingredient(name: "Pineapple", type: .Fruit),
        Ingredient(name: "Plums", type: .Fruit),
        Ingredient(name: "Pomegranates", type: .Fruit),
        Ingredient(name: "Popcorn", type: .Ingredients),
        Ingredient(name: "Potatoes", type: .Vegetable),
        Ingredient(name: "Pumpkin", type: .Vegetable),
        Ingredient(name: "Pumpkin Seeds", type: .Ingredients),
        Ingredient(name: "Paprika", type: .Ingredients),
        Ingredient(name: "Parmesan Cheese", type: .Ingredients),
        Ingredient(name: "Parsnip", type: .Vegetable),
        Ingredient(name: "Peanut Butter", type: .Ingredients),
        Ingredient(name: "Penne Rigate Pasta", type: .Ingredients),
        Ingredient(name: "Peppermint", type: .Ingredients),
        Ingredient(name: "Pistachio Nuts", type: .Ingredients),
        Ingredient(name: "Plum Tomatoes", type: .Vegetable),
        Ingredient(name: "Potato Chips", type: .Ingredients),
        Ingredient(name: "Paprika Powder", type: .Ingredients),
        Ingredient(name: "Parmesan Crisps", type: .Ingredients),
        Ingredient(name: "Peanut Sauce", type: .Ingredients),
        Ingredient(name: "Pepper Jack Cheese", type: .Ingredients),
        Ingredient(name: "Persian Lime", type: .Ingredients),
        Ingredient(name: "Pistachio Ice Cream", type: .Ingredients),
        Ingredient(name: "Plant-Based Yogurt", type: .Ingredients),
        
        // O
        Ingredient(name: "Olives", type: .Ingredients),
        Ingredient(name: "Oregano Leaves", type: .Ingredients),
        Ingredient(name: "Oat Flour", type: .Ingredients),
        Ingredient(name: "Olive Tapenade", type: .Ingredients),
        Ingredient(name: "Oyster Sauce", type: .Ingredients),
        
        // R
        Ingredient(name: "Radishes", type: .Vegetable),
        Ingredient(name: "Raisins", type: .Ingredients),
        Ingredient(name: "Raspberries", type: .Fruit),
        Ingredient(name: "Red Bell Pepper", type: .Vegetable),
        Ingredient(name: "Red Cabbage", type: .Vegetable),
        Ingredient(name: "Rice", type: .Ingredients),
        Ingredient(name: "Rosemary", type: .Ingredients),
        Ingredient(name: "Raspberry Jam", type: .Ingredients),
        Ingredient(name: "Red Chili Pepper", type: .Vegetable),
        Ingredient(name: "Red Kidney Beans (Rajma)", type: .Ingredients),
        Ingredient(name: "Red Onions", type: .Vegetable),
        Ingredient(name: "Red Wine", type: .Ingredients),
        Ingredient(name: "Rice Vinegar", type: .Ingredients),
        Ingredient(name: "Rock Salt", type: .Ingredients),
        Ingredient(name: "Rosewater", type: .Ingredients),
        
        // S
        Ingredient(name: "Saffron", type: .Ingredients),
        Ingredient(name: "Sprouts", type: .Ingredients),
        Ingredient(name: "Salad Greens", type: .Vegetable),
        Ingredient(name: "Salmon", type: .Ingredients),
        Ingredient(name: "Salsa", type: .Ingredients),
        Ingredient(name: "Salt", type: .Ingredients),
        Ingredient(name: "Sesame Oil", type: .Ingredients),
        Ingredient(name: "Sesame Seeds", type: .Ingredients),
        Ingredient(name: "Soy Sauce", type: .Ingredients),
        Ingredient(name: "Spinach (Palak)", type: .Vegetable),
        Ingredient(name: "Starfruit", type: .Fruit),
        Ingredient(name: "Strawberries", type: .Fruit),
        Ingredient(name: "Sugar", type: .Ingredients),
        Ingredient(name: "Sunflower Seeds", type: .Ingredients),
        Ingredient(name: "Sausages", type: .Ingredients),
        Ingredient(name: "Shiitake Mushrooms", type: .Vegetable),
        Ingredient(name: "Soy Yogurt", type: .Ingredients),
        Ingredient(name: "Soybean Oil", type: .Ingredients),
        Ingredient(name: "Spaghetti", type: .Ingredients),
        Ingredient(name: "Spearmint", type: .Ingredients),
        Ingredient(name: "Strawberry Jam", type: .Ingredients),
        Ingredient(name: "Sun-Dried Tomatoes", type: .Ingredients),
        
        // T
        Ingredient(name: "Tamarind", type: .Ingredients),
        Ingredient(name: "Tapioca (Sabudana)", type: .Ingredients),
        Ingredient(name: "Tofu", type: .Ingredients),
        Ingredient(name: "Tomatoes", type: .Vegetable),
        Ingredient(name: "Turmeric", type: .Ingredients),
        Ingredient(name: "Tabasco Sauce", type: .Ingredients),
        Ingredient(name: "Tandoori Paste", type: .Ingredients),
        Ingredient(name: "Tarragon Vinegar", type: .Ingredients),
        Ingredient(name: "Tofu Skins", type: .Ingredients),
        Ingredient(name: "Tomato Juice", type: .Ingredients),
        Ingredient(name: "Turbinado Sugar", type: .Ingredients),
        Ingredient(name: "Taco Shells", type: .Ingredients),
        Ingredient(name: "Tandoori Spice", type: .Ingredients),
        Ingredient(name: "Tofu Stir-Fry", type: .Ingredients),
        Ingredient(name: "Tabouli Salad", type: .Ingredients),
        Ingredient(name: "Tahini Sauce", type: .Ingredients),
        Ingredient(name: "Tamarind Paste", type: .Ingredients),
        Ingredient(name: "Tangerine Juice", type: .Ingredients),
        Ingredient(name: "Tapioca Syrup", type: .Ingredients),
        Ingredient(name: "Taro Chips", type: .Ingredients),
        Ingredient(name: "Tofu Teriyaki", type: .Ingredients),
        Ingredient(name: "Tomato Soup", type: .Ingredients),
        Ingredient(name: "Turmeric Powder", type: .Ingredients),
        
        // U
        Ingredient(name: "Udon Noodles", type: .Ingredients),
        Ingredient(name: "Udon Noodle Soup", type: .Ingredients),
        
        // V
        Ingredient(name: "Vanilla Extract", type: .Ingredients),
        Ingredient(name: "Vinegar", type: .Ingredients),
        Ingredient(name: "Vanilla Beans", type: .Ingredients),
        Ingredient(name: "Vegetable Broth", type: .Ingredients),
        Ingredient(name: "Vermicelli Noodles", type: .Ingredients),
        Ingredient(name: "Vidalia Onions", type: .Vegetable),
        Ingredient(name: "Vegetable Oil", type: .Ingredients),
        Ingredient(name: "Vermouth Wine", type: .Ingredients),
        Ingredient(name: "Vidalia Onion", type: .Vegetable),
        Ingredient(name: "Vanilla Beans", type: .Ingredients),
        Ingredient(name: "Vegetable Stock", type: .Ingredients),
        Ingredient(name: "Vidalia Onion Slices", type: .Vegetable),
        
        // W
        Ingredient(name: "Walnuts", type: .Ingredients),
        Ingredient(name: "Watermelon", type: .Fruit),
        Ingredient(name: "Wheat Germ", type: .Ingredients),
        Ingredient(name: "Whipped Cream", type: .Ingredients),
        Ingredient(name: "White Bread", type: .Ingredients),
        Ingredient(name: "White Rice", type: .Ingredients),
        Ingredient(name: "White Wine", type: .Ingredients),
        Ingredient(name: "Walnut Oil", type: .Ingredients),
        Ingredient(name: "Watermelon Juice", type: .Fruit),
        Ingredient(name: "Wheat Flour", type: .Ingredients),
        Ingredient(name: "White Chocolate", type: .Ingredients),
        Ingredient(name: "White Onions", type: .Vegetable),
        Ingredient(name: "White Vinegar", type: .Ingredients),
        Ingredient(name: "Walnut Pieces", type: .Ingredients),
        Ingredient(name: "Watermelon Slices", type: .Fruit),
        Ingredient(name: "Wheat Pasta", type: .Ingredients),
        Ingredient(name: "Wasabi Paste", type: .Ingredients),
        Ingredient(name: "White Chocolate Chips", type: .Ingredients),
        Ingredient(name: "Watermelon Cubes", type: .Fruit),
        Ingredient(name: "Wasabi Powder", type: .Ingredients),
        Ingredient(name: "White Asparagus Spears", type: .Vegetable),
        Ingredient(name: "White Chocolate Truffles", type: .Ingredients),
        Ingredient(name: "Walnut Sauce", type: .Ingredients),
        Ingredient(name: "Watermelon Smoothie", type: .Fruit),
        Ingredient(name: "Wasabi Mayonnaise", type: .Ingredients),
    
        // Y
        Ingredient(name: "Yogurt", type: .Ingredients),
        Ingredient(name: "Yellow Bell Pepper", type: .Vegetable),
        Ingredient(name: "Yellow Mustard", type: .Ingredients),
        Ingredient(name: "Vanilla Sugar", type: .Ingredients),
        Ingredient(name: "Yogurt Parfait", type: .Ingredients),
        Ingredient(name: "Yellow Cornmeal", type: .Ingredients),
        Ingredient(name: "Yellow Curry Sauce", type: .Ingredients),
        
        // Z
        Ingredient(name: "Ziti Pasta", type: .Ingredients),
        Ingredient(name: "Zucchini Noodles", type: .Vegetable),
    ]
    
    static let sorted = ingredientsList.sorted { i1, i2 in
        return i1.name.compare(i2.name) == .orderedAscending
    }
}
