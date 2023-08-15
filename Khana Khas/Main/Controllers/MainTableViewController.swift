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

    override func viewDidLoad() {
        super.viewDidLoad()
        model = ChatViewModel()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.model?.start()
            self.refresh()
        }
    }
    
    func refresh() {
        if let model = self.model {
            let newItems = model.items
            let changeset = StagedChangeset(source: self.items, target: newItems)
            self.tableView.reload(using: changeset, with: .fade) { data in
                self.items = newItems
            }
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
            cell = tableView.dequeueReusableCell(withIdentifier: "answer")!
        } else if item.isKind(of: ChatQuetion.self) {
            cell = tableView.dequeueReusableCell(withIdentifier: "quetion")!
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "options")!
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let customCell = cell as? ChatTableViewCell {
            customCell.animateFromBottomLeft { _ in
                self.model?.appendNextItemIfNeeded(completion: { refresh in
                    if refresh {
                        self.refresh()
                    }
                })
            }
        } else {
            model?.appendNextItemIfNeeded(completion: { refresh in
                if refresh {
                    self.refresh()
                }
            })
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = self.items[indexPath.row]
        
        if (item.isKind(of: ChatOptions.self)) {
            let options = item as! ChatOptions
            return CGFloat(options.rows * (35 + 8) + 8)
        }
        return UITableView.automaticDimension
    }
}


