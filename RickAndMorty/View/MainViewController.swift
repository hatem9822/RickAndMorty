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
    
    // MARK: - UI Components
    private let gradientBackground = GradientBackgroundView()
    private let charactersTableView = CharactersTableView()

    init(viewModel: RickAndMortyViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        // Load characters from viewModel (already fetched in splash)
        self.characters = viewModel.characters
        
        // Bind state changes for future updates (like favorites)
        self.viewModel.onStateChange = { [weak self] state in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch state {
                case .loaded(let characters):
                    self.characters = characters
                    self.charactersTableView.reloadData()
                case .loading, .error:
                    break
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
        showTableView()
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


    
    private func configureTableView() {
        charactersTableView.configureDataSource(self)
        charactersTableView.configureDelegate(self)
    }
    
    private func showTableView() {
        view.addSubview(charactersTableView)
        configureTableView()
        setupTableViewConstraints()
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





