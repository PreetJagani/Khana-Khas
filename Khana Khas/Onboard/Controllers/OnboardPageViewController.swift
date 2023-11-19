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
        self.dataSource = self
        let storyboard = UIStoryboard(name: "Onboard", bundle: nil)
        let vc1 = storyboard.instantiateViewController(withIdentifier: "vc1")
        vc1.title = "1"
        
        
        let vc2 : OnboardPreferenceViewController = storyboard.instantiateViewController(withIdentifier: "Onboard Pref") as! OnboardPreferenceViewController
        vc2.update(title: "Choose Your Preferred Test", items: PreferredTasteType.allCases.map({ type in
            type.rawValue
        }), selectedIndex: 0)
        vc2.title = "2"
        
        let vc3 : OnboardPreferenceViewController = storyboard.instantiateViewController(withIdentifier: "Onboard Pref") as! OnboardPreferenceViewController
        vc3.update(title: "Choose Your Cooking Style", items: FoodType.allCases.map({ type in
            type.rawValue
        }), selectedIndex: 0)
        vc3.title = "3"
        
        myViewControllers = [vc1, vc2, vc3]
    
        self.setViewControllers([vc1], direction: UIPageViewController.NavigationDirection.forward, animated: true)
    }
    
    func switchToNextPage() {
        guard (self.viewControllers != nil) else {
            return
        }
        
        let curr = self.myViewControllers?.firstIndex(of: viewControllers![0]) ?? 0;
        
        guard curr + 1 < self.myViewControllers?.count ?? 0 else {
            return
        }
        let vc = self.myViewControllers?[curr + 1] as! UIViewController
        
        self.setViewControllers([vc], direction: UIPageViewController.NavigationDirection.forward, animated: true) { _ in
            self.delegate?.pageViewController?(self, didFinishAnimating: true, previousViewControllers: [vc], transitionCompleted: true)
        }
        self.delegate?.pageViewController?(self, willTransitionTo: [vc])
    }
}

extension OnboardPageViewController : UIPageViewControllerDataSource {
    
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
