//
//  ChatOptionsTableViewCell.swift
//  Khana Khas
//
//  Created by Preet Jagani on 13/08/23.
//

import UIKit

class ChatOptionsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var items : [ChatOption] = []
    var rowCountCache : [Int : Int] = [:]
    var numRows : Int = 0
    var layout : ChatOptionsCollectionViewLayout?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
        
        layout = ChatOptionsCollectionViewLayout()
        if let layout {
            layout.delegate = self
            self.collectionView.collectionViewLayout = layout
        }
        self.refresh()
    }
    
    func refresh() {
        items.removeAll()
        rowCountCache = [:]
        numRows = 0
        
        self.addOption(name: "Breakfast", row: 0)
        self.addOption(name: "Snacks", row: 1)
        self.addOption(name: "Dinner", row: 2)
        self.addOption(name: "Lunch", row: 2)
        
        layout?.rowsCount = numRows + 1
    }
    
    func addOption(name: String, row: Int) {
        let option = ChatOption(text: name, rowNumber: row)
        
        let currCount = rowCountCache[row] ?? 0
        rowCountCache[row] = currCount + 1
        numRows = max(row, numRows)
        
        items.append(option)
    }

}

extension ChatOptionsTableViewCell : UICollectionViewDataSource, UICollectionViewDelegate, ChatOptionsFlowLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = self.items[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "option", for: indexPath) as! ChatOptionCollectionViewCell
        
        cell.lable.text = item.text
        
        return cell
    }
    
    func numberOfItemsIn(row: Int) -> Int {
        return self.rowCountCache[row] ?? 1
    }
    
    func rowForIndexPath(indexPath: IndexPath) -> Int {
        let item = self.items[indexPath.item]
        return item.rowNumber
    }
    
}
