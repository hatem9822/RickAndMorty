//
//  ViewController.swift
//  RickAndMorty
//
//  Created by Hatem Cinipi on 6.08.2025.
//

import UIKit

class ViewController: UIViewController {

    private let viewModel: RickAndMortyViewModel

    var characters: [Character] = []
    private var splashView: MainScreenView?


    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CharacterCell.self, forCellReuseIdentifier: "characterCell")
        tableView.backgroundColor = .black
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let v = UIActivityIndicatorView(style: .large)
        v.hidesWhenStopped = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    init(viewModel: RickAndMortyViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        // Bind state changes
        self.viewModel.onStateChange = { [weak self] state in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch state {
                case .loading:
                    self.activityIndicator.startAnimating()
                case .loaded(let characters):
                    self.activityIndicator.stopAnimating()
                    self.characters = characters
                    self.tableView.reloadData()
                case .error:
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func showSplash() {
        // Hide navigation bar during splash
        hideNavigationBar()
        
        let splash = MainScreenView() // Local variable
        splash.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(splash)
        setupSplashConstraints(splash)

        self.splashView = splash
        viewModel.fetchCharacters()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UIView.animate(withDuration: 0.8) {
                self.splashView!.alpha = 0
            } completion: { _ in
                self.splashView!.removeFromSuperview()
                self.splashView = nil

                self.showTableView()
            }
        }
    }
    
    func setupUI() {
        view.backgroundColor = .black
        view.addSubview(activityIndicator)
        setupActivityIndicatorConstraints()
        setupNavigationBar()
        showSplash()
    }
    
    private func setupNavigationBar() {
        title = "Rick & Morty"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
    }
    
    private func hideNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func showNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    func showTableView() {
        // Show navigation bar when table appears
        showNavigationBar()
        
        // Add tableView to view hierarchy
        view.addSubview(tableView)
        
        // Set up table delegate and data source
        setupTableView()
        setupTableViewConstraints()
    }    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if tableView.superview != nil {
            tableView.reloadData()
        }
    }



}

// MARK: - Constraints
private extension ViewController {
    func setupActivityIndicatorConstraints() {
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    func setupTableViewConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func setupSplashConstraints(_ splash: UIView) {
        NSLayoutConstraint.activate([
            splash.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            splash.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            splash.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            splash.heightAnchor.constraint(equalTo: splash.widthAnchor)
        ])
    }
}




