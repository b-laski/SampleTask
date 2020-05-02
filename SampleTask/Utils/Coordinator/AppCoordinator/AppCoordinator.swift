//
//  AppCoordinator.swift
//  SampleTask
//
//  Created by Bartłomiej Łaski on 02/05/2020.
//  Copyright © 2020 Bartłomiej Łaski. All rights reserved.
//

import UIKit

class AppCoordinator: BaseCoordinator {
    
    var window = UIWindow(frame: UIScreen.main.bounds)
    
    override func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        let coordinator = MainCoordinator()
        coordinator.navigationController = navigationController
        coordinator.start(coordinator: coordinator)
    }
}
