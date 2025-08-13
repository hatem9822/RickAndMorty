//
//  CustomTabBar.swift
//  RickAndMorty
//
//  Created by Hatem Cinipi on 13.08.2025.
//

import Foundation
import UIKit

class CustomTabBarController: UITabBarController {
    
    init(viewControllers: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = viewControllers
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        // Configure tab bar appearance (same as your SceneDelegate)
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = AppColor.surface
        tabBarAppearance.shadowColor = .clear
        tabBar.standardAppearance = tabBarAppearance
        tabBar.scrollEdgeAppearance = tabBarAppearance
        tabBar.isTranslucent = false
        tabBar.tintColor = AppColor.accent
        tabBar.unselectedItemTintColor = AppColor.textSecondary
    }
}
