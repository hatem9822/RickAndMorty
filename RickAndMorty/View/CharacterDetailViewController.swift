//
//  CharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by Hatem Cinipi on 7.08.2025.
//

import UIKit

class CharacterDetailViewController: UIViewController {
    private let character: Character
    private var isFavorite: Bool = false
    private let gradientBackground = GradientBackgroundView()

    // MARK: - UI
    private let scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.alwaysBounceVertical = true
        return v
    }()

    private let contentView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let headerImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let headerGradientLayer = CAGradientLayer()

    private let nameLabel: UILabel = {
        let l = UILabel()
        l.font = AppTypography.titleLarge
        l.textColor = AppColor.textPrimary
        l.numberOfLines = 2
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    // MARK: - Components
    private let chipsStack: UIStackView = {
        let s = UIStackView()
        s.axis = .horizontal
        s.spacing = AppSpacing.small
        s.alignment = .leading
        s.distribution = .fillProportionally
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()
    private let infoCard = InfoCardView()

    // MARK: - Init
    init(character: Character) {
        self.character = character
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupFavoriteButton()
        setupLayout()
        configure()
        loadHeaderImage()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerGradientLayer.frame = headerImageView.bounds
    }

    // MARK: - Setup
    private func setupBackground() {
        view.backgroundColor = AppColor.background
        // Gradient background view
        view.addSubview(gradientBackground)
        gradientBackground.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gradientBackground.topAnchor.constraint(equalTo: view.topAnchor),
            gradientBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gradientBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gradientBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

    }
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(headerImageView)
        headerImageView.layer.addSublayer(headerGradientLayer)
        contentView.addSubview(nameLabel)
        contentView.addSubview(chipsStack)
        contentView.addSubview(infoCard)

        infoCard.translatesAutoresizingMaskIntoConstraints = false

        headerGradientLayer.colors = [UIColor.clear.cgColor, AppColor.overlayDark.cgColor]
        headerGradientLayer.locations = [0.5, 1.0]

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            headerImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerImageView.heightAnchor.constraint(equalTo: headerImageView.widthAnchor, multiplier: 0.6),

            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppSpacing.medium),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppSpacing.medium),
            nameLabel.bottomAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: -AppSpacing.medium),

            chipsStack.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: AppSpacing.medium),
            chipsStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppSpacing.medium),
            chipsStack.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -AppSpacing.medium),

            infoCard.topAnchor.constraint(equalTo: chipsStack.bottomAnchor, constant: AppSpacing.medium),
            infoCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppSpacing.medium),
            infoCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppSpacing.medium),
            infoCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -AppSpacing.large)
        ])
    }

    private func setupFavoriteButton() {
        do {
            isFavorite = try CoreDataService.shared.isFavourite(id: Int32(character.id))
        } catch {
            isFavorite = false
        }
        updateFavoriteButton()
    }

    private func updateFavoriteButton() {
        let imageName = isFavorite ? "star.fill" : "star"
        let item = UIBarButtonItem(image: UIImage(systemName: imageName), style: .plain, target: self, action: #selector(toggleFavorite))
        item.tintColor = isFavorite ? AppColor.favoriteActive : AppColor.textSecondary
        navigationItem.rightBarButtonItem = item
    }

    // MARK: - Configure
    private func configure() {
        nameLabel.text = character.name

        // Chips
        chipsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        chipsStack.addArrangedSubview(makeChip(text: character.status.rawValue, tint: statusColor(for: character.status)))
        if !character.type.isEmpty {
            chipsStack.addArrangedSubview(makeChip(text: character.type, tint: AppColor.accent))
        }
        chipsStack.addArrangedSubview(makeChip(text: character.gender.rawValue, tint: AppColor.iconSecondary))

        // Info card
        let infoItems = [
            InfoItem(iconName: "leaf.fill", text: "Species: \(character.species)"),
            InfoItem(iconName: "mappin.circle.fill", text: "Origin: \(character.origin.name)"),
            InfoItem(iconName: "location.fill", text: "Location: \(character.location.name)"),
            InfoItem(iconName: "film.fill", text: "Episodes: \(character.episode.count)")
        ]
        infoCard.configure(with: infoItems)
    }

    private func loadHeaderImage() {
        Task { await loadImage(from: character.image) }
    }

    private func loadImage(from urlString: String) async {
        guard let url = URL(string: urlString) else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            await MainActor.run {
                self.headerImageView.image = UIImage(data: data)
            }
        } catch {
            print("Failed to load image: \(error)")
        }
    }

    // MARK: - Actions
    @objc private func toggleFavorite() {
        do {
            let id = Int32(character.id)
            if isFavorite {
                try CoreDataService.shared.removeFavourite(id: id)
                isFavorite = false
            } else {
                _ = try CoreDataService.shared.addFavourite(id: id)
                isFavorite = true
            }
            updateFavoriteButton()
        } catch {
            print("Failed to toggle favourite: \(error)")
        }
    }

    // MARK: - Helpers
    private func statusColor(for status: Status) -> UIColor {
        switch status {
        case .alive: return AppColor.success
        case .dead: return AppColor.danger
        case .unknown: return AppColor.neutral
        }
    }

    private func makeChip(text: String, tint: UIColor) -> UIView {
        let container = UIView()
        container.backgroundColor = tint.withAlphaComponent(0.2)
        container.layer.cornerRadius = 12
        container.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text = text
        label.font = AppTypography.chip
        label.textColor = AppColor.textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 6),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -6),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10)
        ])

        return container
    }
}


