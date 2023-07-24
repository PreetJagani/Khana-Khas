//
//  OnboardGetStatedViewController.swift
//  Khana Khas
//
//  Created by Preet Jagani on 22/07/23.
//

import UIKit

class OnboardGetStatedViewController: UIViewController {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var getStartLabel: UILabel!
    @IBOutlet weak var iamgeView: UIImageView!
    @IBOutlet weak var parentView: UIView!

    @IBOutlet var parentViewWidth: NSLayoutConstraint!
    @IBOutlet var parentViewLeading: NSLayoutConstraint!
    
    var pageVC : OnboardPageViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for vc in self.children {
            if vc is OnboardPageViewController {
                self.pageVC = vc as? OnboardPageViewController
                self.pageVC?.delegate = self
            }
        }
        self.getStartLabel.alpha = 1
        self.pageControl.alpha = 0
        self.iamgeView.alpha = 0
    }
    
    func showPageControl() {
        self.parentViewLeading.isActive = false
        self.parentViewWidth.isActive = true
        self.parentViewWidth.constant = self.parentView.frame.size.width
        
        UIView.animate(withDuration: 0.5) {
            self.parentViewWidth.constant = 50
            self.getStartLabel.alpha = 0
            self.pageControl.alpha = 1
            self.iamgeView.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    func hidePageControl() {
        
        self.parentViewWidth.isActive = false
        
        UIView.animate(withDuration: 0.5) {
            self.parentViewLeading.isActive = true
            self.getStartLabel.alpha = 1
            self.pageControl.alpha = 0
            self.iamgeView.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
}

extension OnboardGetStatedViewController : UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        let vc = pendingViewControllers[0]
        if vc.title == "1" {
            self.hidePageControl()
        } else {
            self.showPageControl()
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let title = pageVC?.viewControllers?[0].title, let index = Int(title) {
            self.pageControl.currentPage = index - 1
        }
        
    }
}
