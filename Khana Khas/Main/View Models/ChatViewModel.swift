//
//  ChatViewModel.swift
//  Khana Khas
//
//  Created by Preet Jagani on 15/08/23.
//

import UIKit

class ChatViewModel: NSObject {
    
    var items : [ChatItem] = []
    var pendingItems : [ChatItem] = []
    var currIndex = -1
    
    func start() {
        self.pendingItems.append(ChatAnswer(id: 0, text: "Good Morning! How Can I assist you today?"))
        self.pendingItems.append(ChatOptions(id: 1, text: "options", options: [
            ChatOption(text: "🥞 Breakfast", rowNumber: 0),
            ChatOption(text: "🥪 Snacks", rowNumber: 1),
            ChatOption(text: "🥘 Dinner", rowNumber: 2),
            ChatOption(text: "🍽️ Lunch", rowNumber: 2)
        ], rows: 3))
        self.appendNextItemIfNeeded()
    }
    
    func appendNextItemIfNeeded(completion: ((Bool) -> Void)? = nil) {
        guard currIndex + 1 < self.pendingItems.count else {
            completion?(false)
            return
        }
        currIndex += 1
        self.items.append(self.pendingItems[currIndex])
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion?(true)
        }
    }

    func selectChatOption(option: ChatOption, completion: ((Bool) -> Void)? = nil) {
        var text = option.text.dropFirst(2)
        if let firstChar = text.first {
            text.replaceSubrange(text.startIndex...text.startIndex, with: String(firstChar).lowercased())
        }
        self.pendingItems.append(ChatQuetion(id: 3, text: "Suggest me \(text) recipes."))
        self.appendNextItemIfNeeded(completion: completion)
    }
}
