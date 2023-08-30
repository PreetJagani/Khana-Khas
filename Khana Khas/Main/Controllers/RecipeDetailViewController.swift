//
//  RecipeDetailViewController.swift
//  Khana Khas
//
//  Created by Preet Jagani on 30/08/23.
//

import UIKit

class RecipeDetailViewController: UIViewController {

    @IBOutlet weak var foodTitle: UILabel!
    @IBOutlet weak var foodDescription: UILabel!
    
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var loadingView: UIView!
    
    
    var recipe: Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.update()
    }
    
    func update() {
        self.foodTitle.text = recipe?.title
        self.foodDescription.text = recipe?.des
        self.loadingView.isHidden = false
        self.detailView.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.loadingView.isHidden = true
            self.detailView.isHidden = false
        }
    }
}
