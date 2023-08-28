//
//  FoodRecipeTableViewCell.swift
//  Khana Khas
//
//  Created by Preet Jagani on 28/08/23.
//

import UIKit

class FoodRecipeTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    var items: [Recipe] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    func refresh(recipes: [Recipe]) {
        self.items = recipes
    }
}

extension FoodRecipeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = self.items[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recipe", for: indexPath) as! FoodRecipeCollectionViewCell
        cell.refresh(recipe: item)
        
        return cell
    }
    
    
}

class FoodRecipeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var des: UILabel!
    
    func refresh(recipe: Recipe) {
        self.title.text = recipe.title
        self.des.text = recipe.des
    }
    
}
