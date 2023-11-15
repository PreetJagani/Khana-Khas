//
//  ChatItem.swift
//  Khana Khas
//
//  Created by Preet Jagani on 15/08/23.
//

import UIKit

import DifferenceKit

class ChatItem : NSObject, Differentiable {
    
    static let loadingItem : ChatLoadingItem = ChatLoadingItem(id: -1, text: "Loading")
    
    let id: Int
    let text: String
    var completeAnimation = false
    
    init(id: Int, text: String) {
        self.id = id
        self.text = text
    }
    
    var differenceIdentifier: Int {
        return self.id
    }

    func isContentEqual(to source: ChatItem) -> Bool {
        return self.text == source.text
    }
}

class ChatLoadingItem: ChatItem {
    
    fileprivate override init(id: Int, text: String) {
        super.init(id: id, text: text)
    }
}
