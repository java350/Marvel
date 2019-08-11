//
//  MainViewController.swift
//  Marvel
//
//  Created by Volodymyr on 10/8/19.
//  Copyright © 2019 Ukraine. All rights reserved.
//

import UIKit
import RxSwift

class CharactersViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    // MARK: - Properties
    var onSelectCell = PublishSubject<Character>()
    private let viewModel: CharactersViewModel
    private var dataSource: CharacterDataSource?
    private let bag = DisposeBag()
    
    
    // MARK: - Initializations
    
    init(_ viewModel: CharactersViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: CharactersViewController.name, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = viewModel.title
        self.bind()
        self.setupTableView()
        self.indicatorView.startAnimating()
        self.viewModel.fetchCharacters()
    }

    
    // MARK: - Private methods
    
    private func bind() {
        onSelectCell.subscribe(onNext: { (character) in
            Router.share.showChatScreen(for: character)
        }).disposed(by: bag)
        
        viewModel.events.subscribe(onNext: { [weak self] (event) in
            guard let self = self else { return }
            self.indicatorView.stopAnimating()
            switch event {
            case .onFetchCompleted(let newIndexPathsToReload):
                let tableView = self.tableView
                guard let newIndexPathsToReload = newIndexPathsToReload else {
                    tableView?.isHidden = false
                    tableView?.reloadData()
                    return
                }
                let indexPathsToReload = self.visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
                tableView?.reloadRows(at: indexPathsToReload, with: .automatic)
            case .onFetchFailed(let text):
                self.presentAlertWithTitle(title: "Warning", message: text)
            case .selected(_): break
            }
        }).disposed(by: bag)
        
    }

    private func setupTableView() {
        dataSource = viewModel.dataSource(with: tableView)
        tableView?.register(cellClass: CharacterCell.self)
        tableView?.dataSource = dataSource
        tableView?.delegate = self
        tableView.prefetchDataSource = self
        tableView?.tableFooterView = UIView()
    }
}

extension CharactersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onSelectCell.onNext(viewModel.character(at: indexPath.row))
    }
}

extension CharactersViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: viewModel.isLoadingCell) {
            viewModel.fetchCharacters()
        }
    }
}


extension CharactersViewController {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return viewModel.isLoadingCell(for: indexPath)
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        
        return Array(indexPathsIntersection)
    }
}
