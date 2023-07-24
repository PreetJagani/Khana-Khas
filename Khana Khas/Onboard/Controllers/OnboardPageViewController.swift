//
//  OnboardPageViewController.swift
//  Khana Khas
//
//  Created by Preet Jagani on 22/07/23.
//

import UIKit

class OnboardPageViewController: UIPageViewController {
    
    var myViewControllers : [UIViewController]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        let storyboard = UIStoryboard(name: "Onboard", bundle: nil)
        let vc1 = storyboard.instantiateViewController(withIdentifier: "vc1")
        vc1.view.backgroundColor = UIColor.purple
        
        let vc2 = storyboard.instantiateViewController(withIdentifier: "vc1")
        vc2.view.backgroundColor = UIColor.red
        
        myViewControllers = [vc1, vc2]
    
        self.setViewControllers([vc1], direction: UIPageViewController.NavigationDirection.forward, animated: true)
    }
}

extension OnboardPageViewController : UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = self.myViewControllers?.firstIndex(of: viewController), index > 0 else {
            return nil
        }
        return self.myViewControllers?[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = self.myViewControllers?.firstIndex(of: viewController), index + 1 < myViewControllers?.count ?? 2 else {
            return nil
        }
        return self.myViewControllers?[index + 1]
    }
}
