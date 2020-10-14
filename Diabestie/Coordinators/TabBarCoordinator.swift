//
//  TabBarCoordinator.swift
//  Diabestie
//
//  Created by Anika Morris on 10/13/20.
//  Copyright © 2020 Anika Morris. All rights reserved.
//

import Foundation
import UIKit

class TabBarCoordinator: NSObject, Coordinator, UITabBarControllerDelegate {

    //MARK: Properties
    var childCoordinators: [Coordinator] = []
    var tabBarController = UITabBarController()
    
    //MARK: Init
    init(window: UIWindow) {
        window.rootViewController = tabBarController
    }
    
    // MARK: Methods
    func start() {
        let calculatorController = CalculatorController()
        calculatorController.coordinator = self
        calculatorController.tabBarItem = UITabBarItem(title: "Calculate", image: UIImage(systemName: "number.circle"), selectedImage: UIImage(systemName:  "number.circle.fill"))
        
        let profileController = ProfileController()
        profileController.coordinator = self
        profileController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), selectedImage: UIImage(systemName:  "person.circle.fill"))
        
        tabBarController.viewControllers = [calculatorController, profileController]
        tabBarController.selectedViewController = profileController
    }
    
    
}
