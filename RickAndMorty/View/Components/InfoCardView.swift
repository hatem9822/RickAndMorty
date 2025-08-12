import UIKit

final class InfoCardView: UIView {
    
    // MARK: - UI Components
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 14 
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = AppColor.cardBackground
        layer.cornerRadius = 16
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: AppSpacing.medium),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: AppSpacing.medium),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -AppSpacing.medium),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -AppSpacing.medium)
        ])
    }
    
    // MARK: - Public API
    func configure(with items: [InfoItem]) {
        // Clear existing items
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Add new items
        for (index, item) in items.enumerated() {
            let infoRow = makeInfoRow(systemName: item.iconName, text: item.text)
            stackView.addArrangedSubview(infoRow)
            
            // Add divider between items (except for the last one)
            if index < items.count - 1 {
                stackView.addArrangedSubview(makeDivider())
            }
        }
    }
    
    // MARK: - Private Helpers
    private func makeInfoRow(systemName: String, text: String) -> UIView {
        let icon = UIImageView(image: UIImage(systemName: systemName))
        icon.tintColor = AppColor.iconSecondary
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text = text
        label.font = AppTypography.body
        label.textColor = AppColor.textPrimary
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false

        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(icon)
        container.addSubview(label)

        NSLayoutConstraint.activate([
            icon.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            icon.topAnchor.constraint(equalTo: container.topAnchor, constant: 2),
            icon.widthAnchor.constraint(equalToConstant: 20),
            icon.heightAnchor.constraint(equalToConstant: 20),

            label.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 12),
            label.topAnchor.constraint(equalTo: container.topAnchor),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])

        return container
    }
    
    private func makeDivider() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = AppColor.separator
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 1)
        ])
        return view
    }
}

// MARK: - InfoItem Model
struct InfoItem {
    let iconName: String
    let text: String
    
    init(iconName: String, text: String) {
        self.iconName = iconName
        self.text = text
    }
}
