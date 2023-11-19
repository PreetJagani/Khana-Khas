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
    weak var modelDelegate : ChatViewModelDelegate? = nil
    var isAnimating : Bool = false
    
    var activeOption: ChatOption?
    var activeIngredients: [Ingredient]?
    var generatedRecipes: [Recipe] = []
    
    func start(includeGreetings: Bool = true) {
        self.pendingItems.append(ChatAnswer(id: self.nextId(), text: (includeGreetings ? "Good Morning! " : "") + "How Can I assist you today?"))
        self.pendingItems.append(ChatOptions(id: self.nextId(), text: "options", options: [
            ChatOption(text: "🥞 Breakfast", rowNumber: 0),
            ChatOption(text: "🥪 Snacks", rowNumber: 1),
            ChatOption(text: "🥘 Dinner", rowNumber: 2),
            ChatOption(text: "🍽️ Lunch", rowNumber: 2)
        ], rows: 3))
        self.appendNextItemIfNeeded()
    }
    
    func nextId() -> Int {
        currId += 1
        return currId
    }
    
    func appendNextItemIfNeeded() {
        guard self.pendingItems.count > 0 else {
            return
        }
        if self.isAnimating {
            return
        }
        self.isAnimating = true
        let item = self.pendingItems.remove(at: 0)
        self.items.append(item)
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
        self.pendingItems.append(ChatOptions(id: self.nextId(), text: "Ingredients", options: [
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
    
    func generateAnswer(excludeRecipes: [Recipe] = []) {
        self.pendingItems.append(ChatItem.loadingItem)
        self.appendNextItemIfNeeded()
        var foodTime = self.activeOption?.text ?? "  Dinner"
        var foodType = PreferenceManager.shared.getString(forKey: PreferenceManager.PREF_KEY_COOKING_STYLE) ?? "Gujarati"
        foodTime.removeFirst(2)
        FoodSuggestionManager.shared.suggestFood(foodTime: foodTime, foodType: foodType, ingredients: self.activeIngredients?.description ?? "[]", excludeRecipes: excludeRecipes) { suggestions, error in
            
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
            
            DispatchQueue.main.async {
                self.removeLoadingItem()
                
                let isError = foodRecipe.count == 0
                if !isError {
                    self.generatedRecipes.append(contentsOf: foodRecipe)
                    self.pendingItems.append(ChatFoodRecipes(id: self.nextId(), text: "Recipe", recipes: foodRecipe))
                }
                self.addRegenerateOptions(isError: isError)
                self.appendNextItemIfNeeded()
            }
        }
    }
    
    func addRegenerateOptions(isError: Bool) {
        if isError {
            self.pendingItems.append(ChatAnswer(id: self.nextId(), text: "Opps! Something went wrong, Can I assist with anything else?"))
        } else {
            self.pendingItems.append(ChatAnswer(id: self.nextId(), text: "Can I assist with anything else?"))
        }
        self.pendingItems.append(ChatOptions(id: self.nextId(), text: "Regenerate", options: [
            ChatOption(text: "Start over", rowNumber: 0),
            ChatOption(text: isError ? "Try Again" : "More recipes", rowNumber: 0),
//            ChatOption(text: "Edit meal time", rowNumber: 1),
            ChatOption(text: "Edit ingredients", rowNumber: 1)
        ], rows: 2))
    }
    
    func generateQuestionForRegenerate(option: ChatOption) {
        if option.text == "Start over" {
            self.activeOption = nil
            self.activeIngredients = nil
            self.generatedRecipes.removeAll()
            self.pendingItems.append(ChatQuestion(id: self.nextId(), text: option.text))
            self.start(includeGreetings: false)
        } else if option.text == "More recipes" || option.text == "Try Again" {
            self.pendingItems.append(ChatQuestion(id: self.nextId(), text: option.text))
            self.generateAnswer(excludeRecipes: self.generatedRecipes)
        }
        self.appendNextItemIfNeeded()
    }
    
    func removeLoadingItem() {
        if let _ = pendingItems.last as? ChatLoadingItem {
            pendingItems.removeLast()
        }
        
        if let _ = items.last as? ChatLoadingItem {
            items.removeLast()
        }
        self.modelDelegate?.dataUpdated()
    }
}
