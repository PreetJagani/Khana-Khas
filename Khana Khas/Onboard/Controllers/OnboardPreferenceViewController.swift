//
//  OnboardPrefrenceViewController.swift
//  Khana Khas
//
//  Created by Preet Jagani on 27/07/23.
//

import UIKit

class OnboardPreferenceViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var titleText = ""
    var items : [String] = []
    var selectedItem = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.titleLabel.text = self.titleText
    }
    
    func update(title:String, items: [String], selectedIndex: Int) {
        self.items = items
        self.selectedItem = items[selectedIndex]
        self.titleText = title
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
}

class PreferenceSelectionCellView : UITableViewCell {
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var prefOption: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        parentView.layer.cornerRadius = 8
        parentView.layer.borderWidth = 1
    }
    
    func update(title: String, selected: Bool) {
        if selected {
            parentView.layer.borderColor = UIColor.systemIndigo.cgColor
        } else {
            parentView.layer.borderColor = UIColor.lightGray.cgColor
        }
        prefOption.text = title
    }
}


extension OnboardPreferenceViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let index = indexPath.row;
        let item = items[index]
        let selected = selectedItem == item
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Pref Cell") as! PreferenceSelectionCellView
        cell.update(title: item, selected: selected)
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row;
        let item = items[index]
        
        selectedItem = item
        
        if let title = self.title {
            if title == "2" {
                PreferenceManager.shared.set(string: selectedItem, key: PreferenceManager.PREF_KEY_PREFERRED_TEST)
            } else if title == "3" {
                PreferenceManager.shared.set(string: selectedItem, key: PreferenceManager.PREF_KEY_COOKING_STYLE)
            }
        }
        
        reloadTableView()
    }
    
}
