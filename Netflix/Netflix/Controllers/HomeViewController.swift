//
//  HomeViewController.swift
//  Netflix
//
//  Created by Mohamed Ismail on 01/09/2023.
//

import UIKit

class HomeViewController: UIViewController {
    
    let sectionTitles: [String] = ["Spotlight", "Trending Movies", "Trending TV", "Popular Movies", "Upcoming Movies", "Top Rated"]
    
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.separatorStyle = .none
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        table.register(ImageViewTableViewCell.self, forCellReuseIdentifier: ImageViewTableViewCell.identifier)
        return table
    }()

    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.placeholder = "Search for a Movie or TV Show"
        controller.searchBar.searchBarStyle = .prominent
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        view.backgroundColor = .systemRed
        view.addSubview(homeFeedTable)
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
    
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { //rows in table
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //each cell
        guard let imageCell = tableView.dequeueReusableCell(withIdentifier: ImageViewTableViewCell.identifier) as? ImageViewTableViewCell else { return UITableViewCell() }
        
        imageCell.delegate = self
        guard let collectionCell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier) as? CollectionViewTableViewCell else { return UITableViewCell() }
        
        collectionCell.delegate = self
        
        switch indexPath.section {
        case 0:
            imageCell.backgroundColor = .systemBackground
            APICaller.shared.getTrendingTitles { result in
                switch result {
                case.success(let titles):
                    imageCell.passToImageView(with: titles)
                case.failure(let error):
                    print(error)
                }
            }
            return imageCell
            
        case 1:
            APICaller.shared.getTrendingMovies { result in
                switch result {
                case.success(let titles):
                    collectionCell.passToCollectionView(with: titles)
                case.failure(let error):
                    print(error)
                }
            }
            
            
        case 2:
            APICaller.shared.getTrendingTVs { result in
                switch result {
                case.success(let titles):
                    collectionCell.passToCollectionView(with: titles)
                case.failure(let error):
                    print(error)
                }
            }
            
            
        case 3:
            APICaller.shared.getPopularMovies { result in
                switch result {
                case.success(let titles):
                    collectionCell.passToCollectionView(with: titles)
                case.failure(let error):
                    print(error)
                }
            }
            
            
        case 4:
            APICaller.shared.getUpcomingMovies { result in
                switch result {
                case.success(let titles):
                    collectionCell.passToCollectionView(with: titles)
                case.failure(let error):
                    print(error)
                }
            }
            
            
        case 5:
            APICaller.shared.getTopRated { result in
                switch result {
                case.success(let titles):
                    collectionCell.passToCollectionView(with: titles)
                case.failure(let error):
                    print(error)
                }
            }
            
            
        default:
            return UITableViewCell()
        }
        
        return collectionCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { //height for each cell
        if indexPath.section == 0 {
            return 500
        }
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { //height for each header
        return 40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { //title for each header
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) { //for each row header
        guard let header = view as? UITableViewHeaderFooterView else {
            return
        }
        header.textLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
    }
    
}

extension HomeViewController: CollectionViewTableViewCellDelegate {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: Preview) {
        print(viewModel)
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.passToPreviewView(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension HomeViewController: ImageViewTableViewCellDelegate {
    func imageViewTableViewCellDidTapCell(_ cell: ImageViewTableViewCell, viewModel: Preview) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.passToPreviewView(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


