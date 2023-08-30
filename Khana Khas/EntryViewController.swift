//
//  LaunchViewController.swift
//  Khana Khas
//
//  Created by Preet Jagani on 29/07/23.
//

import UIKit

class EntryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        PanesManager.shared.rootNavigationController = self.navigationController
        PanesManager.shared.loadInitialVc()
    }

}
