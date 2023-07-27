//
//  OnboardWelcomePageController.swift
//  Khana Khas
//
//  Created by Preet Jagani on 27/07/23.
//

import UIKit
import Lottie

class OnboardWelcomePageController: UIViewController {
    
    @IBOutlet weak var animationContainer: UIView!
    private var animationView: LottieAnimationView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        animationView = .init(name: "welcome")
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .loop
        animationView?.translatesAutoresizingMaskIntoConstraints = false

        self.animationContainer.addSubview(animationView!)
        
        animationView?.leadingAnchor.constraint(equalTo: animationContainer.leadingAnchor).isActive = true
        animationView?.trailingAnchor.constraint(equalTo: animationContainer.trailingAnchor).isActive = true
        animationView?.topAnchor.constraint(equalTo: animationContainer.topAnchor).isActive = true
        animationView?.bottomAnchor.constraint(equalTo: animationContainer.bottomAnchor).isActive = true
        
        animationView!.play()
    }

}
