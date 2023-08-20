//
//  ChatOptionsTableViewCell.swift
//  Khana Khas
//
//  Created by Preet Jagani on 13/08/23.
//

import UIKit

protocol ChatOptionDelegate : AnyObject {
    func didSelectOption(option: ChatOption)
}

class ChatOptionsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var items : [ChatOption] = []
    var rowCountCache : [Int : Int] = [:]
    var numRows : Int = 0
    var layout : ChatOptionsCollectionViewLayout?
    var selectedIndex = -1
    weak var optionsDelegate : ChatOptionDelegate?
    
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
//        self.refresh()
    }
    
    func refresh(options: ChatOptions) {
        items.removeAll()
        rowCountCache = [:]
        numRows = 0
        
        options.options.forEach { option in
            self.addOption(option: option)
        }
        
        layout?.rowsCount = numRows + 1
    }
    
    func addOption(option: ChatOption) {
        let row = option.rowNumber
        
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
        
        let selected = self.selectedIndex == indexPath.row
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "option", for: indexPath) as! ChatOptionCollectionViewCell
        
        cell.lable.text = item.text
        if selected {
            cell.parent.layer.backgroundColor = UIColor.systemGray3.cgColor
        } else {
            cell.parent.layer.backgroundColor = UIColor.secondarySystemBackground.cgColor
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedIndex != -1 {
            return
        }
        let item = self.items[indexPath.row]
        optionsDelegate?.didSelectOption(option: item)
        
        selectedIndex = indexPath.row
        
        collectionView.reloadItems(at: [indexPath])
    }
    
    func numberOfItemsIn(row: Int) -> Int {
        return self.rowCountCache[row] ?? 1
    }
    
    func rowForIndexPath(indexPath: IndexPath) -> Int {
        let item = self.items[indexPath.item]
        return item.rowNumber
    }
    
}
