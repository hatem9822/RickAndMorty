
import Foundation

protocol RickAndMortyViewModelProtocol:AnyObject {
      func fetchCharacters()
      func getFavouriteCharacters() -> [Character]
      var onStateChange: ((RickAndMortyViewModel.CharactersState) -> Void)? { get set }
      func toggleFavourite(_ characterID: Int32)
  }

class RickAndMortyViewModel: RickAndMortyViewModelProtocol {
    private let networkService : NetworkService
    enum CharactersState { case loading, loaded([Character]), error(Error) }
    var onStateChange: ((CharactersState) -> Void)?
    private(set) var characters: [Character] = []
    
    init(networkService: NetworkService, onStateChange:  ((CharactersState) -> Void)?) {
        self.networkService = networkService
        self.onStateChange = onStateChange
    }
    
    func fetchCharacters() {
        let url = Endpoints.characters.url
        onStateChange?(.loading)
        networkService.fetchData(from: url, list: [], iteration: 0) { result in
            switch result {
            case .success(let data):
                self.characters = data
                self.onStateChange?(.loaded(data))
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
