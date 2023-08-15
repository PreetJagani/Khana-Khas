//
//  ChatItem.swift
//  Khana Khas
//
//  Created by Preet Jagani on 15/08/23.
//

import UIKit

import DifferenceKit

class ChatItem : NSObject, Differentiable {
    
    let id: Int
    let text: String
    
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
