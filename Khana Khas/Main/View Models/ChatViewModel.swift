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

    func generateQuetion(option: ChatOption) {
        var text = option.text.dropFirst(2)
        if let firstChar = text.first {
            text.replaceSubrange(text.startIndex...text.startIndex, with: String(firstChar).lowercased())
        }
        self.pendingItems.append(ChatQuetion(id: self.nextId(), text: "Suggest me \(text) recipes."))
        self.appendNextItemIfNeeded()
        self.generateAnswer(option: option)
    }
    
    func generateAnswer(option: ChatOption) {
        FoodSuggetionManager.shared.suggestFood(promt: "") { suggetion in
            self.pendingItems.append(ChatAnswer(id: self.nextId(), text: suggetion))
            self.appendNextItemIfNeeded()
        }
    }
}
