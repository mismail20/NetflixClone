//
//  DownloadsTableViewCell.swift
//  Netflix
//
//  Created by Mohamed Ismail on 13/09/2023.
//

import UIKit
import SDWebImage

protocol DownloadsViewTableViewCellDelegate: AnyObject {
    func downloadsViewTableViewCellDidTapCell(_ cell: DownloadsTableViewCell, viewModel: Preview)
}

class DownloadsTableViewCell: UITableViewCell {
    
    static let identifier = "DownloadsTableViewCell"
    
    private var currentTitle: String = ""
    private var currentOverview: String = ""
    private var currentPosterPath: String = ""
    
    weak var delegate: DownloadsViewTableViewCellDelegate?
    
    private let downloadsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "sample")
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(downloadsImageView)
        configureConstraints()
        setupTapGesture()
    }
    
   
    override func layoutSubviews() {
        super.layoutSubviews()
        downloadsImageView.frame = contentView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureConstraints() {
        let libraryImageViewConstraints = [
             downloadsImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
             downloadsImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
         ]

        NSLayoutConstraint.activate(libraryImageViewConstraints)
    }
    
    public func passToDownloadsViewCell(currentTitle: String, currentOverview: String, currentPosterPath: String) {
        self.currentTitle = currentTitle
        self.currentOverview = currentOverview
        self.currentPosterPath = currentPosterPath
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(currentPosterPath)") else { return }
        downloadsImageView.sd_setImage(with: url, placeholderImage: nil)
    }
    
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        downloadsImageView.isUserInteractionEnabled = true
        downloadsImageView.addGestureRecognizer(tapGesture)
    }

    @objc private func handleTap() {
        APICaller.shared.getMovie(query: self.currentTitle + " trailer") { [weak self] result in
            switch result {
            case.success(let videoElement):
                self?.delegate?.downloadsViewTableViewCellDidTapCell(self!, viewModel: Preview(title: self!.currentTitle, youtubeView: videoElement, titleOverview: self!.currentOverview, posterPath: self!.currentPosterPath))

                
            case.failure(let error):
                print(error)
            }
        }

    }
    

}

