//
//  FoodRecipeTableViewCell.swift
//  Khana Khas
//
//  Created by Preet Jagani on 28/08/23.
//

import UIKit

class FoodRecipeTableViewCell: ChatTableViewCell {

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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recipe = self.items[indexPath.row]
        PanesManager.shared.showRecipeDetailVc(recipe: recipe)
    }
}

class FoodRecipeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var des: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var recipe: Recipe?
    
    func refresh(recipe: Recipe) {
        self.recipe = recipe
        self.title.text = recipe.title
        self.des.text = recipe.des
        self.refreshImage()
    }
    
    @objc func refreshImage() {
        ImageManager.shared.getImage(name: recipe?.title ?? "") {[weak self] image in
            guard let urls = image["urls"] as? [String: Any], let url = urls["thumb"] as? String else {
                return
            }
            NetworkManager.shared.getImage(url: url) { image in
                guard let image else {
                    return
                }
                DispatchQueue.main.async {
                    self?.imageView.image = image
                }
            }
        }
    }
    
}
