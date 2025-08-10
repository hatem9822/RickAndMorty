
import Foundation

  protocol RickAndMortyViewModelProtocol {
      func fetchCharacters()
      var onStateChange: ((RickAndMortyViewModel.CharactersState) -> Void)? { get set }
  }

class RickAndMortyViewModel {
    private let networkService : NetworkService
    enum CharactersState { case loading, loaded([Character]), error(Error) }
    var onStateChange: ((CharactersState) -> Void)?
    private(set) var characters: [Character] = []
    
    init(onStateChange:  ((CharactersState) -> Void)?) {
        self.networkService = NetworkService()
        self.onStateChange = onStateChange
    }
    
    func fetchCharacters() {
        let url = URL(string: "https://rickandmortyapi.com/api/character")!
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
}
