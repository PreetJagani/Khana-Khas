//
//  PanesManager.swift
//  Khana Khas
//
//  Created by Preet Jagani on 30/08/23.
//

import UIKit

class PanesManager: NSObject {
    
    var rootNavigationController: UINavigationController?
    
    static let shared = PanesManager()
    
    private override init() {
        
    }
    
    private func getMainStoryBoard() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    func loadInitialVc() {
        if PrefrenceManager.shared.getBool(forKey: PrefrenceManager.PREF_KEY_ONBOARD_COMPLETE) {
            self.showMainVC()
        } else {
            self.showOnboardVc()
        }
    }
    
    func showOnboardVc() {
        let storyboard = UIStoryboard(name: "Onboard", bundle: nil)
        if let vc = storyboard.instantiateInitialViewController() {
            self.rootNavigationController?.setViewControllers([vc], animated: true)
        }
    
    }
    
    func showMainVC() {
        if let vc = self.getMainStoryBoard().instantiateInitialViewController() {
            self.rootNavigationController?.setViewControllers([vc], animated: true)
        }
    }
    
    func showRecipeDetailVc(recipe: Recipe) {
        let storyboard = self.getMainStoryBoard()
        if let vc = storyboard.instantiateViewController(withIdentifier: "recipeDetail") as? RecipeDetailViewController {
            vc.recipe = recipe
            self.rootNavigationController?.show(vc, sender: nil)
        }
    }
    
}
