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
        let storyboard : UIStoryboard
        if PrefrenceManager.shared.getBool(forKey: PrefrenceManager.PREF_KEY_ONBOARD_COMPLETE) {
            storyboard = UIStoryboard(name: "Main", bundle: nil)
        } else {
            storyboard = UIStoryboard(name: "Onboard", bundle: nil)
        }
        
        if let vc = storyboard.instantiateInitialViewController() {
            self.navigationController?.setViewControllers([vc], animated: true)
        }
    }

}
