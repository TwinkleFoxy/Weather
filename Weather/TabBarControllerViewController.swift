//
//  TabBarControllerViewController.swift
//  Weather
//
//  Created by Алексей Однолько on 20.02.2024.
//

import UIKit

final class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        // Создаем первый вью контроллер и его соответствующий таб
        let mainViewController = MainViewController()
        let mainNavigationController = UINavigationController(rootViewController: mainViewController)
        if let originalImage = UIImage(named: "home")?.resize(to: CGSize(width: 30, height: 30)) {
            mainViewController.tabBarItem = UITabBarItem(title: "Home", image: originalImage, tag: 0)
        }
        tabBar.barTintColor = UIColor.white
        
        tabBar.tintColor = UIColor.blue
        // Создаем второй вью контроллер и его соответствующий таб
        let favouriteViewController = FavouriteViewController()
        let favouriteNavigationController = UINavigationController(rootViewController: favouriteViewController)
        if let originalImage = UIImage(named: "heart")?.resize(to: CGSize(width: 30, height: 30)) {
            favouriteViewController.tabBarItem = UITabBarItem(title: "Favorite", image: originalImage, tag: 1)
        }
        // Устанавливаем вью контроллеры в таб бар
        viewControllers = [mainNavigationController, favouriteNavigationController]
    }
}
