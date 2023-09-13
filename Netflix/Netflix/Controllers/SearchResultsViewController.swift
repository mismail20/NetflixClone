//
//  SearchResultsViewController.swift
//  Netflix
//
//  Created by Mohamed Ismail on 03/09/2023.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func searchResultsViewControllerDidTapCell(_ cell: SearchResultsViewController, viewModel: Preview)
}

class SearchResultsViewController: UIViewController {
    
    public var titles: [Title] = [Title]()
    
    weak var delegate: SearchResultsViewControllerDelegate?
    
    public let searchResultsCollectionView: UICollectionView = {
       
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
        view.addSubview(searchResultsCollectionView)
        
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
        print(titles)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultsCollectionView.frame = view.bounds
    }
}

extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else { return UICollectionViewCell()}
        
        let title = titles[indexPath.row]
        cell.passToTitleViewCell(with: title.poster_path ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        guard let titleName = title.original_title else { return }
        guard let titleOverview = title.overview else { return }
        guard let posterPath = title.poster_path ?? title.poster_path else { return }
        
        APICaller.shared.getMovie(query: titleName + " trailer") { [weak self] result in
            switch result {
            case.success(let videoElement):
                
                let title = self?.titles[indexPath.row]
                
                self?.delegate?.searchResultsViewControllerDidTapCell(self!, viewModel: Preview(title: titleName, youtubeView: videoElement, titleOverview: titleOverview, posterPath: posterPath))
                
            case.failure(let error):
                print(error)
            }
        }
    }
    
}
