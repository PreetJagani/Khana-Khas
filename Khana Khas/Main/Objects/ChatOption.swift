//
//  ChatOption.swift
//  Khana Khas
//
//  Created by Preet Jagani on 15/08/23.
//

import UIKit

class ChatOption {
    
    let text : String
    let rowNumber : Int
    
    init(text: String, rowNumber: Int) {
        self.text = text
        self.rowNumber = rowNumber
    }
}

class ChatOptions : ChatItem {
    
    let options : [ChatOption]
    let rows : Int
    var selectedIndex: Int
    
    init(id: Int, text: String, options: [ChatOption], rows: Int, selectedIndex: Int = -1) {
        self.options = options
        self.rows = rows
        self.selectedIndex = selectedIndex
        super.init(id: id, text: text)
    }
}
