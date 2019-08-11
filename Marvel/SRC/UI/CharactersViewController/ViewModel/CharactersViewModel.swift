//
//  MainViewModel.swift
//  Marvel
//
//  Created by Volodymyr on 10/8/19.
//  Copyright © 2019 Ukraine. All rights reserved.
//

import Foundation
import RxSwift

class CharactersViewModel: ViewModel {
    
    enum Event {
        case selected(Character)
        case onFetchCompleted([IndexPath]?)
        case onFetchFailed(String)
    }
    
    
    // MARK: - Properties
    
    var title: String? = "Cgaracters"
    var events = PublishSubject<Event>()
    
    private var characters = [Character]()
    private var offset = 0
    private (set) var total = 0
    private var isFetchInProgress = false
    
    var currentCount: Int {
        return characters.count
    }
    
    var totalCount: Int {
        return total
    }
    
    
    // MARK: - Public methods
    
    func dataSource(with tableView: UITableView?) -> CharacterDataSource {
        return CharacterDataSource(tableView, viewModel: self)
    }
    
    func character(at index: Int) -> Character {
        return self.characters[index]
    }
    
    func add(_ character: Character) {
        self.characters.append(character)
    }
    
    func add(_ characters: [Character]) {
        self.characters.append(contentsOf: characters)
    }
    
    func fetchCharacters() {
        guard !isFetchInProgress else {
            return
        }
        
        isFetchInProgress = true

        CharactersContext().execute(offset: offset) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let responce):
                    self.offset += Constants.Server.offset
                    self.total = (responce.data?.total).default
                    self.add(responce.characters)
                    if (responce.data?.offset).default > 0 {
                        let indexPathsToReload = self.calculateIndexPathsToReload(from: responce.characters)
                        self.events.onNext(.onFetchCompleted(indexPathsToReload))
                    } else {
                        self.events.onNext(.onFetchCompleted(.none))
                    }
                case .failure(let error):
                    self.events.onNext(.onFetchFailed(error.localizedDescription))
                    print("Error \(String(describing: error))")
                }
                self.isFetchInProgress = false
            }
        }
    }
    
    
    // MARK: - Private methods
    private func calculateIndexPathsToReload(from newCharacters: [Character]) -> [IndexPath] {
        let startIndex = characters.count - newCharacters.count
        let endIndex = startIndex + newCharacters.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}

extension CharactersViewModel {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= self.currentCount
    }
}
