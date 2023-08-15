//
//  ViewController.swift
//  Khana Khas
//
//  Created by Preet Jagani on 22/07/23.
//

import UIKit
import DifferenceKit

class MainTableViewController: UITableViewController {
    
    var items : [ChatItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBar.isHidden = false
//        self.navigationController?.navigationBar.prefersLargeTitles = true
//        self.title = "Khana Khash"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.addItem(item: ChatItem(id: 1, name: "left"))
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.addItem(item: ChatItem(id: 2, name: "options"))
            }
        }
    }
    
    func addItem(item : ChatItem) {
        var newItems = self.items
        
        newItems.append(item)
        
        let changeset = StagedChangeset(source: self.items, target: newItems)
        
        self.tableView.reload(using: changeset, with: .fade) { data in
            self.items = newItems
        }
//        self.tableView.reload(using: changeset,
//                              deleteSectionsAnimation: UITableView.RowAnimation.fade,
//                              insertSectionsAnimation: UITableView.RowAnimation.fade,
//                              reloadSectionsAnimation: UITableView.RowAnimation.fade,
//                              deleteRowsAnimation: UITableView.RowAnimation.left,
//                              insertRowsAnimation: UITableView.RowAnimation.right,
//                              reloadRowsAnimation:UITableView.RowAnimation.fade) { data in
//            self.items = newItems
//        }
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
        
        if item.name == "left" {
            cell = tableView.dequeueReusableCell(withIdentifier: "chat")!
        } else if item.name == "options" {
            cell = tableView.dequeueReusableCell(withIdentifier: "chat options")!
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "chat right")!
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let customCell = cell as? ChatTableViewCell {
            customCell.animateFromBottomLeft()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = self.items[indexPath.row]
        
        if (item.name == "options") {
            return 200
        }
        return UITableView.automaticDimension
    }
}

class ChatItem : Differentiable {
    
    let id: Int
    let name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    var differenceIdentifier: Int {
        return self.id
    }

    func isContentEqual(to source: ChatItem) -> Bool {
        return self.name == source.name
    }
}


