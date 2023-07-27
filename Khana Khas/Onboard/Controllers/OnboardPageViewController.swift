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
        vc1.view.backgroundColor = UIColor.purple
        vc1.title = "1"
        
        
        let vc2 : OnboardPrefrenceViewController = storyboard.instantiateViewController(withIdentifier: "Onboard Pref") as! OnboardPrefrenceViewController
        vc2.update(title: "Choose Your Preferred Test", items: ["Regular", "Sweet", "Spicy"], selectedIndex: 0)
        vc2.title = "2"
        
        let vc3 : OnboardPrefrenceViewController = storyboard.instantiateViewController(withIdentifier: "Onboard Pref") as! OnboardPrefrenceViewController
        vc3.update(title: "Choose Your Cooking Style", items: ["Gujarati", "Pujabi", "South Inidain", "Ilalian"], selectedIndex: 0)
        vc3.title = "3"
        
        myViewControllers = [vc1, vc2, vc3]
    
        self.setViewControllers([vc1], direction: UIPageViewController.NavigationDirection.forward, animated: true)
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
