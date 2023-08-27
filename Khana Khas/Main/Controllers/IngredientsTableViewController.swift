//
//  IngredientsTableViewController.swift
//  Khana Khas
//
//  Created by Preet Jagani on 26/08/23.
//

import UIKit
import DifferenceKit

class IngredientsTableViewController: UITableViewController {
    
    var items: [IngredientSection] = []
    
    var selectedItems: Set<Ingredient> = []
    var sectionIndex: [String] = []
    var searchString: String = ""
    var ingredientType: IngredientType = .All
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didPressDoneBtn))
        self.navigationItem.leftBarButtonItems = [cancelBtn]
        
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(didPressDoneBtn))
        self.navigationItem.rightBarButtonItems = [doneBtn]
        
        self.navigationItem.searchController = UISearchController()
        self.navigationItem.searchController?.searchResultsUpdater = self
        self.navigationItem.searchController?.searchBar.scopeButtonTitles = FoodSuggestionManager.ingredientsTypes
        self.navigationItem.searchController?.scopeBarActivation = .onTextEntry
        
        self.refresh()
    }
    
    func refresh() {
        let data = FoodSuggestionManager.shared.ingredientsSection(searchString: self.searchString, type: self.ingredientType)
        
        self.sectionIndex = data.sectionIndex
        self.items = data.sections
        
//        let newItems = data.sections
//        let changeset = StagedChangeset(source: self.items, target: newItems)
//        self.tableView.reload(using: changeset, with: .fade) { data in
//            self.items = data
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                self.tableView.scrollToRow(at: IndexPath(row: self.items.count - 1, section: 0), at: .bottom, animated: true)
//            }
//        }
        self.tableView.reloadData()
    }
    
    @objc func didPressDoneBtn(sender: Any) {
        
    }
}

// data source, delegate
extension IngredientsTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = self.items[section]
        return section.items.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = self.items[section]
        return section.header
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "item", for: indexPath) as! IngredientItemTableViewCell
        
        let food = self.itemForIndexPath(indexPath: indexPath)
        
        if self.selectedItems.contains(food) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        cell.titleText.text = food.name
        
        return cell;
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.sectionIndex
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
    
    func itemForIndexPath(indexPath : IndexPath) -> Ingredient {
        let section = self.items[indexPath.section]
        let food = section.items[indexPath.row]
        
        return food
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let food = self.itemForIndexPath(indexPath: indexPath)
        
        if self.selectedItems.contains(food) {
            self.selectedItems.remove(food)
        } else {
            self.selectedItems.insert(food)
        }
        self.tableView.reloadRows(at: [indexPath], with: .none)
    }
}

extension IngredientsTableViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        self.searchString = searchController.searchBar.text ?? ""
        self.ingredientType = IngredientType(rawValue: searchController.searchBar.selectedScopeButtonIndex) ?? .All
        self.refresh()
    }
    
    
}
