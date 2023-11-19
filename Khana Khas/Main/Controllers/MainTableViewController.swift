//
//  ViewController.swift
//  Khana Khas
//
//  Created by Preet Jagani on 22/07/23.
//

import UIKit
import DifferenceKit

class MainTableViewController: UITableViewController {
    
    var model : ChatViewModel?
    var items : [ChatItem] = []
    var choosingIngredients = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        
        let customItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(didPressSettingsButton))
        
        self.navigationItem.rightBarButtonItems = [customItem]
        model = ChatViewModel()
        model?.modelDelegate = self
        self.model?.start()
    }
    
    @objc func didPressSettingsButton(sender: Any?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navVc = storyboard.instantiateViewController(withIdentifier: "settings") as! UINavigationController
        
//        if let ingredientsVc = navVc.viewControllers[0] as? IngredientsTableViewController {
//            ingredientsVc.ingredientsDelegate = self
//            ingredientsVc.selectedItems = Set(model?.activeIngredients ?? [])
//        }
        self.navigationController?.present(navVc, animated: true)
    }
    
    func refresh() {
        if let model = self.model {
            let newItems = model.items
            let changeset = StagedChangeset(source: self.items, target: newItems)
            self.tableView.reload(using: changeset, with: .fade) { data in
                self.items = data
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.tableView.scrollToRow(at: IndexPath(row: self.items.count - 1, section: 0), at: .bottom, animated: true)
                }
            }
//            self.tableView.reload(using: changeset, deleteSectionsAnimation: .top, insertSectionsAnimation: .bottom, reloadSectionsAnimation: .fade, deleteRowsAnimation: .top, insertRowsAnimation: .bottom, reloadRowsAnimation: .fade) { data in
//                self.items = data
//            }
        }
    }
}

// delegate, datasource
extension MainTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell
        let item = self.items[indexPath.row]
        
        if item.isKind(of: ChatAnswer.self) {
            let answer = item as! ChatAnswer
            cell = tableView.dequeueReusableCell(withIdentifier: "answer")!
            (cell as! ChatAnswerTableViewCell).refresh(text: answer.text)
        } else if item.isKind(of: ChatQuestion.self) {
            let quetion = item as! ChatQuestion
            cell = tableView.dequeueReusableCell(withIdentifier: "quetion")!
            (cell as! ChatQuetionTableViewCell).refresh(text: quetion.text)
        } else if item.isKind(of: ChatOptions.self) {
            let options = item as! ChatOptions
            cell = tableView.dequeueReusableCell(withIdentifier: "options")!
            if let cell = cell as? ChatOptionsTableViewCell {
                cell.optionsDelegate = self
                cell.refresh(options: options, selectedIndex: options.selectedIndex)
            }
        } else if item.isKind(of: ChatFoodRecipes.self) {
            let recipes = item as! ChatFoodRecipes
            cell = tableView.dequeueReusableCell(withIdentifier: "recipe")!
            if let cell = cell as? FoodRecipeTableViewCell {
                cell.refresh(recipes: recipes.recipes)
            }
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "loading")!
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let item = self.items[indexPath.row]
        if item.completeAnimation {
            if let customCell = cell as? ChatTableViewCell {
                customCell.restorePosition()
            }
            return
        }
        if let customCell = cell as? ChatTableViewCell {
            customCell.animateFromBottom { _ in
                tableView.beginUpdates()
                tableView.endUpdates()
                self.model?.appendNextItemIfNeeded()
            }
        } else {
            model?.appendNextItemIfNeeded()
        }
        item.completeAnimation = true
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = self.items[indexPath.row]
        
        if (item.isKind(of: ChatOptions.self)) {
            let options = item as! ChatOptions
            return CGFloat(options.rows * (35 + 8) + 8)
        } else if (item.isKind(of: ChatFoodRecipes.self)) {
            return 250
        }
        return UITableView.automaticDimension
    }
}

extension MainTableViewController : ChatViewModelDelegate, ChatOptionDelegate, IngredientsSelectionDelegate {
    
    func dataUpdated() {
        self.refresh()
    }
    
    func didSelectOption(chatOptions: ChatOptions, option: ChatOption) {
        if self.items.last != chatOptions {
            return
        }
        if (chatOptions.text == "Ingredients") {
            self.showIngredientsVc()
        } else if (chatOptions.text == "Regenerate") {
            if option.text == "Edit ingredients" {
                self.showIngredientsVc()
            } else {
                model?.generateQuestionForRegenerate(option: option)
            }
        } else {
            model?.generateQuestion(option: option)
        }
    }
    
    func showIngredientsVc() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navVc = storyboard.instantiateViewController(withIdentifier: "ingredients") as! UINavigationController
        
        if let ingredientsVc = navVc.viewControllers[0] as? IngredientsTableViewController {
            ingredientsVc.ingredientsDelegate = self
            ingredientsVc.selectedItems = Set(model?.activeIngredients ?? [])
        }
        self.navigationController?.present(navVc, animated: true)
    }
    
    func shouldSelectOption(chatOptions: ChatOptions, optionTitle: String) -> Bool {
        if optionTitle == "Ingredients" {
            return false
        }
        if optionTitle == "Edit ingredients" {
            return false
        }
        return self.items.last == chatOptions
    }
    
    func didSelectIngredient(ingredients: [Ingredient]) {
        if (ingredients.count > 0) {
            model?.didSelectIngredients(ingredients: ingredients)
        }
    }
}


