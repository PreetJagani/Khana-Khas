//
//  ChatOptionsTableViewCell.swift
//  Khana Khas
//
//  Created by Preet Jagani on 13/08/23.
//

import UIKit

protocol ChatOptionDelegate : AnyObject {
    func didSelectOption(title: String, option: ChatOption)
    
    func shouldSelectOption(option: ChatOption) -> Bool
}

class ChatOptionsTableViewCell: ChatTableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var items : [ChatOption] = []
    var rowCountCache : [Int : Int] = [:]
    var layout : ChatOptionsCollectionViewLayout?
    var selectedIndex = -1
    weak var options: ChatOptions?
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
    }
    
    func refresh(options: ChatOptions, selectedIndex: Int) {
        self.selectedIndex = selectedIndex
        self.options = options
        items.removeAll()
        rowCountCache = [:]
        
        options.options.forEach { option in
            self.addOption(option: option)
        }
        
        layout?.rowsCount = options.rows + 1
    }
    
    func addOption(option: ChatOption) {
        let row = option.rowNumber
        
        let currCount = rowCountCache[row] ?? 0
        rowCountCache[row] = currCount + 1
        
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
        cell.update(text: item.text, selected: selected)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedIndex != -1 {
            return
        }
        let item = self.items[indexPath.row]
        optionsDelegate?.didSelectOption(title: options?.text ?? "", option: item)
        if (!(self.optionsDelegate?.shouldSelectOption(option: item) ?? true)) {
            return
        }
        self.options?.selectedIndex = indexPath.row
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
