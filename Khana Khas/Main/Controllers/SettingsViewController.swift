//
//  SettingsViewController.swift
//  Khana Khas
//
//  Created by Preet Jagani on 19/11/23.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    var items : [SettingsItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didPressDoneButton))
        self.title = "Settings"
        self.refresh()
    }
    
    func refresh() {
        self.items.removeAll()
        let selectedFoodType = PrefrenceManager.shared.getString(forKey: PrefrenceManager.PREF_KEY_COOKING_STYLE)
        for fType in FoodType.allCases {
            let selected = selectedFoodType == fType.rawValue
            self.items.append(SettingsItem(name: fType.rawValue, selected: selected))
        }
        self.tableView.reloadData()
    }
    
    @objc func didPressDoneButton(sender: Any?) {
        self.dismiss(animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // Preferred Test
        return "Cooking Style"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "item", for: indexPath)
        
        if let cell = cell as? SettingsItemTableViewCell {
            let item = items[indexPath.row]
            cell.titleText.text = item.name
            cell.accessoryType = item.selected ? .checkmark : .none
        }
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        PrefrenceManager.shared.set(string: item.name, key: PrefrenceManager.PREF_KEY_COOKING_STYLE)
        self.refresh()
    }
}
