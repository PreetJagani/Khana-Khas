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
    
    @IBOutlet weak var detailView: ShimmerView!
    
    var recipe: Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.update()
        
        self.detailView.setTemplateWithSubviews(true)
    }
    
    func update() {
        self.foodTitle.text = recipe?.title
        self.foodDescription.text = recipe?.des
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.detailView.setTemplateWithSubviews(false)
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
