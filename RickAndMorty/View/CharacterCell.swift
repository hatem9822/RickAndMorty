//
//  CharacterCell.swift
//  RickAndMorty
//
//  Created by Hatem Cinipi on 7.08.2025.
//

import UIKit

class CharacterCell: UITableViewCell {
    let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.systemGray3.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let statusLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let favoriteImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "star"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let statusDot: UIView = {
    let v = UIView()
    v.layer.cornerRadius = 3
    v.translatesAutoresizingMaskIntoConstraints = false
    return v
}()

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var currentCharacterId: Int32?
    private var isFavorite = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupCellAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    private func setupUI() {
        // Add subviews to contentView
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 8
        layer.masksToBounds = false
        let selectedBG = UIView()
        selectedBG.backgroundColor = UIColor.systemGray.withAlphaComponent(0.15)
        selectedBackgroundView = selectedBG
        selectionStyle = .default
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleFavorite))
        favoriteImageView.addGestureRecognizer(gestureRecognizer)
        favoriteImageView.isUserInteractionEnabled = true

        contentView.addSubview(containerView)
        containerView.addSubview(characterImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(statusLabel)
        containerView.addSubview(statusDot)        
        containerView.addSubview(favoriteImageView)
        // Setup constraints
        setupConstraints()
    }
    
    private func setupCellAppearance() {
        // Make cell background transparent
        backgroundColor = .clear
        selectionStyle = .none
        
        // Remove any default cell styling
        backgroundView = nil
        selectedBackgroundView = nil
    }
    
    func configure(with character: Character) {
        nameLabel.text = "\(character.id) - \(character.name)"
        currentCharacterId = Int32(character.id)

        let statusColor: UIColor
        switch character.status {
        case .alive:
            statusLabel.text = "Alive"
            statusColor = .systemGreen
        case .dead:
            statusLabel.text = "Dead"
            statusColor = .systemRed
        case .unknown:
            statusLabel.text = "Unknown"
            statusColor = .tertiaryLabel
        }

        statusDot.backgroundColor = statusColor
        characterImageView.layer.borderColor = statusColor.withAlphaComponent(0.4).cgColor

        characterImageView.image = UIImage(systemName: "person.crop.circle") // placeholder
        Task { await loadImage(from: character.image) }

        // Resolve favourite state from Core Data
        if let id = currentCharacterId {
            do {
                isFavorite = try CoreDataService.shared.isFavourite(id: id)
            } catch {
                isFavorite = false
                print("Failed to read favourite state: \(error)")
            }
        } else {
            isFavorite = false
        }
        updateFavouriteUI()
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

    private func setupConstraints() {
        NSLayoutConstraint.activate([
   
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

         
            characterImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            characterImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            characterImageView.widthAnchor.constraint(equalToConstant: 70),
            characterImageView.heightAnchor.constraint(equalToConstant: 70),

       
            nameLabel.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

            statusDot.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            statusDot.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            statusDot.widthAnchor.constraint(equalToConstant: 6),
            statusDot.heightAnchor.constraint(equalToConstant: 6),

            statusLabel.leadingAnchor.constraint(equalTo: statusDot.trailingAnchor, constant: 6),
            statusLabel.centerYAnchor.constraint(equalTo: statusDot.centerYAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            statusLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            
            favoriteImageView.leadingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -40),
            favoriteImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            favoriteImageView.widthAnchor.constraint(equalToConstant: 20),
            favoriteImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    @objc func toggleFavorite() {
        guard let id = currentCharacterId else { return }
        do {
            if isFavorite {
                try CoreDataService.shared.removeFavourite(id: id)
                isFavorite = false
            } else {
                _ = try CoreDataService.shared.addFavourite(id: id)
                isFavorite = true
            }
            updateFavouriteUI()
        } catch {
            print("Favourite toggle failed: \(error)")
        }
    }

    private func updateFavouriteUI() {
        if isFavorite {
            favoriteImageView.image = UIImage(systemName: "star.fill")
            favoriteImageView.tintColor = .systemYellow
        } else {
            favoriteImageView.image = UIImage(systemName: "star")
            favoriteImageView.tintColor = .tertiaryLabel
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        characterImageView.image = nil
        nameLabel.text = nil
        currentCharacterId = nil
        isFavorite = false
        updateFavouriteUI()
    }
}

