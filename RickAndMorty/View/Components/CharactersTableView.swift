import UIKit

final class CharactersTableView: UITableView {
    
    init() {
        super.init(frame: .zero, style: .plain)
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTableView() {
        register(CharacterCell.self, forCellReuseIdentifier: "characterCell")
        backgroundColor = .clear
        separatorStyle = .none
        showsVerticalScrollIndicator = false
        contentInset = UIEdgeInsets(top: AppSpacing.large, left: 0, bottom: AppSpacing.large, right: 0)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configureDataSource(_ dataSource: UITableViewDataSource) {
        self.dataSource = dataSource
    }
    
    func configureDelegate(_ delegate: UITableViewDelegate) {
        self.delegate = delegate
    }
}
