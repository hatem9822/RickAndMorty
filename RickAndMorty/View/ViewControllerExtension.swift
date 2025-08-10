//
//  ViewControllerExtension.swift
//  RickAndMorty
//
//  Created by Hatem Cinipi on 7.08.2025.
//
import Foundation
import UIKit

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "characterCell", for: indexPath) as! CharacterCell
        let character = characters[indexPath.row]
        cell.configure(with: character)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let character = characters[indexPath.row]
        
        // Create detail view controller (you'll need to create this)
        let detailVC = CharacterDetailViewController(character: character)
        UIView.performWithoutAnimation {
            navigationController?.pushViewController(detailVC, animated: false)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}

