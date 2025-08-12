//
//  SceneDelegate.swift
//  RickAndMorty
//
//  Created by Hatem Cinipi on 6.08.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        
        let viewModel = RickAndMortyViewModel(networkService: NetworkService(), onStateChange: nil)
        let viewController = MainViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        
        let favouriteVC = FavouriteViewController(viewModel: viewModel)
        let favouriteNavController = UINavigationController(rootViewController: favouriteVC)
        favouriteNavController.tabBarItem = UITabBarItem(title: "Favourite", image: UIImage(systemName: "heart"), selectedImage: UIImage(systemName: "heart.fill"))

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [navigationController, favouriteNavController]

        // Configure tab bar appearance
        configureTabBar(tabBarController)
        
        // Configure navigation bars using the component
        NavigationBarConfigurator.configure(navigationController, title: "All Characters", prefersLargeTitles: false)
        NavigationBarConfigurator.configure(favouriteNavController, title: "Favourites", prefersLargeTitles: false)

        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        window?.tintColor = AppColor.accent
    }
    
    private func configureTabBar(_ tabBarController: UITabBarController) {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = AppColor.surface
        tabBarAppearance.shadowColor = .clear
        tabBarController.tabBar.standardAppearance = tabBarAppearance
        tabBarController.tabBar.scrollEdgeAppearance = tabBarAppearance
        tabBarController.tabBar.isTranslucent = false
        tabBarController.tabBar.tintColor = AppColor.accent
        tabBarController.tabBar.unselectedItemTintColor = AppColor.textSecondary
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}

