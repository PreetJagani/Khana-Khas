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
        model?.modelDelegate = self
        self.model?.start()
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
        } else if item.isKind(of: ChatQuetion.self) {
            let quetion = item as! ChatQuetion
            cell = tableView.dequeueReusableCell(withIdentifier: "quetion")!
            (cell as! ChatQuetionTableViewCell).refresh(text: quetion.text)
        } else if item.isKind(of: ChatOptions.self) {
            let options = item as! ChatOptions
            cell = tableView.dequeueReusableCell(withIdentifier: "options")!
            if let cell = cell as? ChatOptionsTableViewCell {
                cell.optionsDelegate = self
                cell.refresh(options: options)
            }
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "loading")!
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let customCell = cell as? ChatTableViewCell {
            customCell.animateFromBottom { _ in
                self.model?.appendNextItemIfNeeded()
            }
        } else {
            model?.appendNextItemIfNeeded()
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

extension MainTableViewController : ChatViewModelDelegate, ChatOptionDelegate {
    
    func dataUpdated() {
        self.refresh()
    }
    
    func didSelectOption(option: ChatOption) {
        model?.generateQuetion(option: option)
    }
    
    func shoudSelectOption(option: ChatOption) -> Bool {
        if (option.text == "Ingredients") {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ingredients")
            self.navigationController?.present(vc, animated: true)
            
            return false
        }
        return true
    }
}


