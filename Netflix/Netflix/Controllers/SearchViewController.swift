//
//  SearchViewController.swift
//  Netflix
//
//  Created by Mohamed Ismail on 01/09/2023.
//

import UIKit

class SearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        title = "Search"
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
    }
    
    private let searchController: UISearchController = {
        
        let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.placeholder = "Search for a Movie or TV Show"
        controller.searchBar.searchBarStyle = .prominent
        return controller
    }()
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              let resultsController = searchController.searchResultsController as? SearchResultsViewController else { return }
           
        resultsController.delegate = self
        APICaller.shared.search(query: query) { result in
            switch result {
            case.success(let titles):
                resultsController.titles = titles
                DispatchQueue.main.async { [] in
                    resultsController.searchResultsCollectionView.reloadData()
                }
                
            case.failure(let error):
                print(error)
            }
        }
        }
    }

extension SearchViewController: SearchResultsViewControllerDelegate {
    func searchResultsViewControllerDidTapCell(_ cell: SearchResultsViewController, viewModel: Preview) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.passToPreviewView(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

