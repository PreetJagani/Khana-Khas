//
//  SettingsViewController.swift
//  Khana Khas
//
//  Created by Preet Jagani on 19/11/23.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    var items: [SettingsSectionItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didPressDoneButton))
        self.title = "Settings"
        self.refresh()
    }
    
    func refresh() {
        self.items.removeAll()
        
        var preferredTestItems: [SettingsItem] = []
        
        let selectedTasteType = PreferenceManager.shared.getString(forKey: PreferenceManager.PREF_KEY_PREFERRED_TEST)
        for tType in PreferredTasteType.allCases {
            let selected = selectedTasteType == tType.rawValue
            preferredTestItems.append(SettingsItem(name: tType.rawValue, selected: selected))
        }
        
        var fTypeItems: [SettingsItem] = []
        
        let selectedFoodType = PreferenceManager.shared.getString(forKey: PreferenceManager.PREF_KEY_COOKING_STYLE)
        for fType in FoodType.allCases {
            let selected = selectedFoodType == fType.rawValue
            fTypeItems.append(SettingsItem(name: fType.rawValue, selected: selected))
        }
        
        self.items.append(SettingsSectionItem(name: "Preferred Taste", items: preferredTestItems))
        self.items.append(SettingsSectionItem(name: "Cooking Style", items: fTypeItems))
        
        self.tableView.reloadData()
    }
    
    @objc func didPressDoneButton(sender: Any?) {
        self.dismiss(animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.items.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items[section].items.count
    }
    
    func itemFor(indexPath: IndexPath) -> SettingsItem {
        return self.items[indexPath.section].items[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let item = self.items[section]
        return item.name
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "item", for: indexPath)
        
        if let cell = cell as? SettingsItemTableViewCell {
            let item = itemFor(indexPath: indexPath)
            cell.titleText.text = item.name
            cell.accessoryType = item.selected ? .checkmark : .none
        }
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = itemFor(indexPath: indexPath)
        if indexPath.section == 0 {
            PreferenceManager.shared.set(string: item.name, key: PreferenceManager.PREF_KEY_PREFERRED_TEST)
        } else if indexPath.section == 1 {
            PreferenceManager.shared.set(string: item.name, key: PreferenceManager.PREF_KEY_COOKING_STYLE)
        }
        self.refresh()
    }
}
