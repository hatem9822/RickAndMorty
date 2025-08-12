import UIKit

final class NavigationBarConfigurator {
    
    static func configure(_ navigationController: UINavigationController, 
                         title: String, 
                         prefersLargeTitles: Bool = false) {
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = AppColor.surface
        appearance.titleTextAttributes = [.foregroundColor: AppColor.textPrimary]
        appearance.largeTitleTextAttributes = [.foregroundColor: AppColor.textPrimary]
        appearance.shadowColor = .clear
        
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        navigationController.navigationBar.compactAppearance = appearance
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.tintColor = AppColor.accent
        navigationController.view.backgroundColor = AppColor.background
        
        navigationController.topViewController?.title = title
        navigationController.topViewController?.navigationController?.navigationBar.prefersLargeTitles = prefersLargeTitles
    }
}
