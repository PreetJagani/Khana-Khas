//
//  RecipeDetailViewController.swift
//  Khana Khas
//
//  Created by Preet Jagani on 30/08/23.
//

import UIKit
import UIView_Shimmer

class RecipeDetailViewController: UIViewController {

    @IBOutlet weak var foodTitle: UILabel!
    @IBOutlet weak var foodDescription: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var ingredients: UILabel!
    @IBOutlet weak var instruction: UILabel!
    
    @IBOutlet weak var detailView: ShimmerView!
    
    var recipe: Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.update()
        
        self.detailView.setTemplateWithSubviews(true)
    }
    
    func update() {
        guard let recipe = recipe else {
            return
        }
        self.foodTitle.text = recipe.title
        self.foodDescription.text = recipe.des
                
        FoodSuggestionManager.shared.recipeDetail(name: recipe.title, info: recipe.des) { detail in
            DispatchQueue.main.async {
                if let ingredients = detail["ingredients"] as? String, let instruction = detail["instruction"] as? String {
                    self.ingredients.text = ingredients
                    self.instruction.text = instruction
                }
                self.detailView.setTemplateWithSubviews(false)                
            }
        }
    
        ImageManager.shared.getImage(name: recipe.title) {[weak self] image in
            guard let urls = image["urls"] as? [String: Any], let url = urls["full"] as? String, let blurHash = image["blur_hash"] as? String else {
                return
            }
            let blurImage = UIImage(blurHash: blurHash, size: self?.imageView.frame.size ?? .zero)
            DispatchQueue.main.async {
                self?.imageView.image = blurImage
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

class ShimmerView: UIView, ShimmeringViewProtocol {
    
    var shimmeringAnimatedItems: [UIView] {
        get {
            return self.subviews
        }
    }
    
}
