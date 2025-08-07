
import Foundation

protocol RickAndMortyViewModelProtocol {
    func fetchCharacters()
    var onDataLoaded: ([Character]) -> Void? { get set }
}

class RickAndMortyViewModel {
    private let networkService : NetworkService
    var onDataLoaded: ([Character]) -> Void?
    
    init(onDataLoaded: @escaping ([Character]) -> Void?) {
        self.networkService = NetworkService()
        self.onDataLoaded = onDataLoaded
    }
    
    func fetchCharacters() {
        let url = URL(string: "https://rickandmortyapi.com/api/character")!
        networkService.fetchData(from: url, list: [], iteration: 0) { result in
            switch result {
            case .success(let data):
                self.onDataLoaded(data)
            case .failure(let error):
                print("Error fetching characters: \(error)")
            }
        }
    }
}
