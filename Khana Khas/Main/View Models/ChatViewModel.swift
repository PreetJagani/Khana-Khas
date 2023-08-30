//
//  ChatViewModel.swift
//  Khana Khas
//
//  Created by Preet Jagani on 15/08/23.
//

import UIKit

protocol ChatViewModelDelegate : AnyObject {
    func dataUpdated()
}

class ChatViewModel: NSObject {
    
    var items : [ChatItem] = []
    var currId = 0
    var pendingItems : [ChatItem] = []
    var currIndex = -1
    weak var modelDelegate : ChatViewModelDelegate? = nil
    var isAnimating : Bool = false
    
    var activeOption: ChatOption?
    var activeIngredients: [Ingredient]?
    
    func start() {
        self.pendingItems.append(ChatAnswer(id: self.nextId(), text: "Good Morning! How Can I assist you today?"))
        self.pendingItems.append(ChatOptions(id: self.nextId(), text: "options", options: [
            ChatOption(text: "🥞 Breakfast", rowNumber: 0),
            ChatOption(text: "🥪 Snacks", rowNumber: 1),
            ChatOption(text: "🥘 Dinner", rowNumber: 2),
            ChatOption(text: "🍽️ Lunch", rowNumber: 2)
        ], rows: 3))
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.appendNextItemIfNeeded()
        }
    }
    
    func nextId() -> Int {
        currId += 1
        return currId
    }
    
    func appendNextItemIfNeeded() {
        guard currIndex + 1 < self.pendingItems.count else {
            return
        }
        if self.isAnimating {
            return
        }
        self.isAnimating = true
        self.currIndex += 1
        self.items.append(self.pendingItems[currIndex])
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isAnimating = false
            self.modelDelegate?.dataUpdated()
            self.appendNextItemIfNeeded()
        }
    }

    func generateQuestion(option: ChatOption) {
        var text = option.text.dropFirst(2)
        if let firstChar = text.first {
            text.replaceSubrange(text.startIndex...text.startIndex, with: String(firstChar).lowercased())
        }
        self.pendingItems.append(ChatQuestion(id: self.nextId(), text: "Suggest me \(text) recipes."))
        self.appendNextItemIfNeeded()
        self.activeOption = option
        self.showChooseIngredients()
    }
    
    func showChooseIngredients() {
        self.pendingItems.append(ChatAnswer(id: self.nextId(), text: "Sure, Select ingredients"))
        self.pendingItems.append(ChatOptions(id: self.nextId(), text: "ingredients", options: [
            ChatOption(text: "Ingredients", rowNumber: 0),
        ], rows: 1))
        self.appendNextItemIfNeeded()
    }
    
    func didSelectIngredients(ingredients: [Ingredient]) {
        var text = ""
        for ingredient in ingredients {
            text.append("\(ingredient.name), ")
        }
        text.removeLast(2)
        self.activeIngredients = ingredients
        self.pendingItems.append(ChatQuestion(id: self.nextId(), text: text))
        self.generateAnswer()
    }
    
    func generateAnswer() {
        self.pendingItems.append(ChatItem.loadingItem)
        self.appendNextItemIfNeeded()
        var foodTime = self.activeOption?.text ?? "  Dinner"
        foodTime.removeFirst(2)
        FoodSuggestionManager.shared.suggestFood(foodTime: foodTime, foodType: "Gujarati", ingredients: self.activeIngredients?.description ?? "[]") { suggestions, error in
            self.pendingItems.remove(at: self.currIndex)
            self.items.remove(at: self.currIndex)
            self.currIndex -= 1
            
            var foodRecipe: Array<Recipe> = []
            do {
                if let recipesString = suggestions["res"] as? String,
                   let data = recipesString.data(using: .utf8),
                   let recipes = try JSONSerialization.jsonObject(with: data) as? [[String:Any]] {
                    for recipe in recipes {
                        if let name = recipe["food_name"] as? String, let info = recipe["info"] as? String {
                            foodRecipe.append(Recipe(title: name, des: info))
                        }
                    }
                }
            } catch let e {
                print(e)
            }
            
            
            self.pendingItems.append(ChatFoodRecipes(id: self.nextId(), text: "Recipe", recipes: foodRecipe))
            self.appendNextItemIfNeeded()
        }
    }
}
