
import Foundation

protocol RickAndMortyViewModelProtocol:AnyObject {
      func fetchCharacters()
      func getFavouriteCharacters() -> [Character]
      var onStateChange: ((RickAndMortyViewModel.CharactersState) -> Void)? { get set }
      func toggleFavourite(_ characterID: Int32)
      var characters: [Character] { get }
  }

class RickAndMortyViewModel: RickAndMortyViewModelProtocol {
    private let networkService : NetworkService
    enum CharactersState { case loading, loaded([Character]), error(Error) }
    var onStateChange: ((CharactersState) -> Void)?
    var characters: [Character] = []
    
    init(networkService: NetworkService, onStateChange:  ((CharactersState) -> Void)?) {
        self.networkService = networkService
        self.onStateChange = onStateChange
    }
    
    func fetchCharacters() {
        onStateChange?(.loading)
        networkService.fetchAllCharacters { result in
            switch result {
            case .success(let characters):
                self.characters = characters
                self.onStateChange?(.loaded(characters))
            case .failure(let error):
                print("Error fetching characters: \(error)")
                self.onStateChange?(.error(error))
            }
        }
    }

    func getFavouriteCharacters() -> [Character] {
        do {
            let favIds = try CoreDataService.shared.allFavourites().map { Int($0.id) }
            guard !favIds.isEmpty else { return [] }
            let favSet = Set(favIds)
            return characters.filter { favSet.contains($0.id) }
        } catch {
            return []
        }
    }
    
    func toggleFavourite(_ characterID: Int32) {
        do {
            if try CoreDataService.shared.isFavourite(id: characterID) {
                try CoreDataService.shared.removeFavourite(id: characterID)
            }
            else {
                try CoreDataService.shared.addFavourite(id: characterID)
            }
        } catch {
            print(error)
        }
        
    }
}
