import UIKit

enum AppColor {
    // Core surfaces & accents
    static let surface: UIColor = UIColor(red: 0.08, green: 0.08, blue: 0.10, alpha: 1.0)
    static let background: UIColor = .black
    static let accent: UIColor = UIColor(red: 0.00, green: 0.95, blue: 0.60, alpha: 1.0)

    // Text & icons
    static let textPrimary: UIColor = .white
    static let textSecondary: UIColor = UIColor(white: 1.0, alpha: 0.70)
    static let iconPrimary: UIColor = .white
    static let iconSecondary: UIColor = UIColor(white: 1.0, alpha: 0.75)
    static let iconMuted: UIColor = UIColor(white: 1.0, alpha: 0.5)

    // Cards & lines
    static let cardBackground: UIColor = UIColor(red: 0.18, green: 0.18, blue: 0.20, alpha: 1.0)
    static let separator: UIColor = UIColor(white: 1.0, alpha: 0.10)
    static let border: UIColor = .systemGray3

    // Gradients
    static let gradientTop: UIColor = UIColor(red: 0.12, green: 0.07, blue: 0.25, alpha: 1.0)
    static let gradientMid: UIColor = UIColor(red: 0.04, green: 0.27, blue: 0.33, alpha: 1.0)
    static let gradientBottom: UIColor = .systemGray 
    static let overlayDark: UIColor = UIColor.black.withAlphaComponent(0.8)

    // Status
    static let success: UIColor = .systemGreen
    static let danger: UIColor = .systemRed
    static let neutral: UIColor = .systemGray
    static let favoriteActive: UIColor = .systemYellow
}


