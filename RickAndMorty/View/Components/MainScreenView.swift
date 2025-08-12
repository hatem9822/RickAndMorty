import UIKit
import Foundation

class MainScreenView: UIView {
    let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "rickAndMorty")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        addSubview(imageView)
        setupConstraints()
    }

        private func setupConstraints() {
        NSLayoutConstraint.activate([
        imageView.topAnchor.constraint(equalTo: topAnchor),
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
}
}