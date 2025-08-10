//
//  CharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by Hatem Cinipi on 7.08.2025.
//

import UIKit

class CharacterDetailViewController: UIViewController {
    
    private let character: Character
    
    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.quaternaryLabel.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textAlignment = .center
        label.textColor = .label
        label.backgroundColor = .tertiarySystemFill
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let speciesLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // Container card for info
    private let containerView: UIView = {
        let v = UIView()
        v.backgroundColor = .secondarySystemBackground
        v.layer.cornerRadius = 16
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    // Additional info labels
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let genderLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let originLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let episodesLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let infoStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    init(character: Character) {
        self.character = character
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureWithCharacter()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(characterImageView)
        view.addSubview(nameLabel)
        view.addSubview(statusLabel)
        view.addSubview(speciesLabel)
        view.addSubview(containerView)
        containerView.addSubview(infoStackView)

        // Add info labels to stack
        infoStackView.addArrangedSubview(typeLabel)
        infoStackView.addArrangedSubview(genderLabel)
        infoStackView.addArrangedSubview(originLabel)
        infoStackView.addArrangedSubview(locationLabel)
        infoStackView.addArrangedSubview(episodesLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            characterImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            characterImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            characterImageView.widthAnchor.constraint(equalToConstant: 200),
            characterImageView.heightAnchor.constraint(equalToConstant: 200),
            
            nameLabel.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            statusLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            speciesLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 10),
            speciesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            speciesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: speciesLabel.bottomAnchor, constant: 20),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            infoStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            infoStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            infoStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            infoStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }
    
    private func configureWithCharacter() {
        nameLabel.text = character.name
        speciesLabel.text = character.species
        
        switch character.status {
        case .alive:
            statusLabel.text = "  Alive  "
        case .dead:
            statusLabel.text = "  Dead  "
        case .unknown:
            statusLabel.text = "  Unknown  "
        }
        
        // Load character image
        Task {
            await loadImage(from: character.image)
        }

        // Additional info
        let typeText = character.type.isEmpty ? "-" : character.type
        typeLabel.text = "Type: \(typeText)"
        genderLabel.text = "Gender: \(character.gender.rawValue)"
        originLabel.text = "Origin: \(character.origin.name)"
        locationLabel.text = "Location: \(character.location.name)"
        episodesLabel.text = "Episodes: \(character.episode.count)"
    }
    
    private func loadImage(from urlString: String) async {
        guard let url = URL(string: urlString) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            await MainActor.run {
                characterImageView.image = UIImage(data: data)
            }
        } catch {
            print("Failed to load image: \(error)")
        }
    }

} 
