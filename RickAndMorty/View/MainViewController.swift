//
//  ViewController.swift
//  RickAndMorty
//
//  Created by Hatem Cinipi on 6.08.2025.
//

import UIKit

class MainViewController: UIViewController {

    var viewModel: RickAndMortyViewModelProtocol

    var characters: [Character] = []
    private var splashView: MainScreenView?
    
    // MARK: - UI Components
    private let gradientBackground = GradientBackgroundView()
    private let charactersTableView = CharactersTableView()
    private let loadingView = LoadingView()

    init(viewModel: RickAndMortyViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        // Bind state changes
        self.viewModel.onStateChange = { [weak self] state in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch state {
                case .loading:
                    self.loadingView.startLoading()
                case .loaded(let characters):
                    self.loadingView.stopLoading()
                    self.characters = characters
                    self.charactersTableView.reloadData()
                case .error:
                    self.loadingView.stopLoading()
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if charactersTableView.superview != nil {
            charactersTableView.reloadData()
        }
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = AppColor.background
        addGradientBackground()
        addLoadingView()
        showSplash()
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

    private func addLoadingView() {
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func hideNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func showNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func configureTableView() {
        charactersTableView.configureDataSource(self)
        charactersTableView.configureDelegate(self)
    }
    
    private func showTableView() {
        showNavigationBar()
        view.addSubview(charactersTableView)
        configureTableView()
        setupTableViewConstraints()
    }

    private func showSplash() {
        hideNavigationBar()
        let splash = MainScreenView()
        splash.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(splash)
        setupSplashConstraints(splash)
        self.splashView = splash
        viewModel.fetchCharacters()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UIView.animate(withDuration: 0.8) {
                self.splashView?.alpha = 0
            } completion: { _ in
                self.splashView?.removeFromSuperview()
                self.splashView = nil
                self.showTableView()
            }
        }
    }

    // MARK: - Constraints
    private func setupTableViewConstraints() {
        NSLayoutConstraint.activate([
            charactersTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            charactersTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            charactersTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            charactersTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupSplashConstraints(_ splash: UIView) {
        NSLayoutConstraint.activate([
            splash.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            splash.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            splash.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            splash.heightAnchor.constraint(equalTo: splash.widthAnchor)
        ])
    }
}


// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "characterCell", for: indexPath) as! CharacterCell
        let character = characters[indexPath.row]
        
        cell.onToggleFavorite = { [weak self] id in
            guard let self = self else { return }
            self.viewModel.toggleFavourite(id)
            tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
        }
        
        cell.configure(with: character)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let character = characters[indexPath.row]
        
        let detailVC = CharacterDetailViewController(character: character)
        UIView.performWithoutAnimation {
            navigationController?.pushViewController(detailVC, animated: false)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}





