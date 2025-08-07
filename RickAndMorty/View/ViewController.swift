//
//  ViewController.swift
//  RickAndMorty
//
//  Created by Hatem Cinipi on 6.08.2025.
//

import UIKit

class ViewController: UIViewController {
    let rickAndMortyViewModel : RickAndMortyViewModel
    var characters : [Character] = []
    var splashView: MainScreenView?
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CharacterCell.self, forCellReuseIdentifier: "characterCell")
        tableView.backgroundColor = .black
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    init() {
        // Temporary placeholder
        self.rickAndMortyViewModel = RickAndMortyViewModel(onDataLoaded: { _ in })
        super.init(nibName: nil, bundle: nil)
        rickAndMortyViewModel.onDataLoaded = { [weak self] result in
            self?.characters = result
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func showSplash() {
    let splash = MainScreenView() // Local variable
    splash.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(splash)
    NSLayoutConstraint.activate([
    splash.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    splash.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    splash.widthAnchor.constraint(equalToConstant: 500),   // Adjust size as needed
    splash.heightAnchor.constraint(equalToConstant: 500)
])

    self.splashView = splash
    rickAndMortyViewModel.fetchCharacters()

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
        showSplash()

    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    func showTableView() {
        // Add tableView to view hierarchy
        view.addSubview(tableView)
        
        // Set up table delegate and data source
        setupTableView()
        
    }    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }



}




