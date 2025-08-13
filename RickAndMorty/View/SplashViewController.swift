//
//  SplashViewController.swift
//  RickAndMorty
//
//  Created by Hatem Cinipi on 12.08.2025.
//

import UIKit

final class SplashViewController: UIViewController {
    // MARK: - UI
    private let splash = MainScreenView()
    private let gradientBackground = GradientBackgroundView()

    // MARK: - State
    private var didFinishAnimation = false
    private var didFinishLoading = false

    // MARK: - Dependencies
    private let viewModel: RickAndMortyViewModelProtocol

    // Default convenience injection
    init(viewModel: RickAndMortyViewModelProtocol = RickAndMortyViewModel(networkService: NetworkService(), onStateChange: nil)) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bindViewModel()
        fetchData()
        animateLogo()
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = AppColor.background
        addGradientBackground()
        addSplash()
    }

    private func addGradientBackground() {
        view.addSubview(gradientBackground)
        gradientBackground.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gradientBackground.topAnchor.constraint(equalTo: view.topAnchor),
            gradientBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gradientBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gradientBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func addSplash() {
        splash.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(splash)
        NSLayoutConstraint.activate([
            splash.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            splash.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            splash.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            splash.heightAnchor.constraint(equalTo: splash.widthAnchor)
        ])
    }

    // MARK: - VM Binding & Data
    private func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .loaded:
                self.didFinishLoading = true
                self.tryProceed()
            case .error:
                // Proceed even if fetch fails to avoid dead-end
                self.didFinishLoading = true
                self.tryProceed()
            case .loading:
                break
            }
        }
    }

    private func fetchData() {
        viewModel.fetchCharacters()
    }

    // MARK: - Animation
    private func animateLogo() {
        splash.alpha = 0
        UIView.animate(withDuration: 1.0, animations: {
            self.splash.alpha = 1
            self.splash.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { _ in
            UIView.animate(withDuration: 0.5, animations: {
                self.splash.transform = .identity
            }) { _ in
                self.didFinishAnimation = true
                self.tryProceed()
            }
        }
    }

    // MARK: - Navigation
    private func tryProceed() {
        guard didFinishAnimation, didFinishLoading else { return }
        navigateToTabBar()
    }

    private func navigateToTabBar() {
        // Create MainViewController with loaded data
        let mainVC = MainViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: mainVC)
        navigationController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        
        // Create FavouriteViewController with same viewModel
        let favouriteVC = FavouriteViewController(viewModel: viewModel)
        let favouriteNavController = UINavigationController(rootViewController: favouriteVC)
        favouriteNavController.tabBarItem = UITabBarItem(title: "Favourite", image: UIImage(systemName: "heart"), selectedImage: UIImage(systemName: "heart.fill"))

        // Create TabBarController
        let tabBarController = CustomTabBarController(viewControllers: [navigationController, favouriteNavController])
        
        
        // Configure navigation bars using the component (same as SceneDelegate)
        NavigationBarConfigurator.configure(navigationController, title: "All Characters", prefersLargeTitles: false)
        NavigationBarConfigurator.configure(favouriteNavController, title: "Favourites", prefersLargeTitles: false)

        // Present tab bar controller
        tabBarController.modalPresentationStyle = .fullScreen
        tabBarController.modalTransitionStyle = .crossDissolve
        present(tabBarController, animated: true)
    }
    
}