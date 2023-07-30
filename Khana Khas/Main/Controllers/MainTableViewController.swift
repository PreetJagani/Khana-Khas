//
//  ViewController.swift
//  Khana Khas
//
//  Created by Preet Jagani on 22/07/23.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    var items : [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBar.isHidden = false
//        self.navigationController?.navigationBar.prefersLargeTitles = true
//        self.title = "Khana Khash"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.items.append("left")
            self.tableView.reloadData()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.items.append("right")
            self.tableView.reloadData()
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
        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "chat")!
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "chat right")!
        }
        return cell
    }
    
}


