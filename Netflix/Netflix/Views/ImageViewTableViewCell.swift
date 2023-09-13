//
//  ImageViewTableViewCell.swift
//  Netflix
//
//  Created by Mohamed Ismail on 02/09/2023.
//

import UIKit
protocol ImageViewTableViewCellDelegate: AnyObject {
    func imageViewTableViewCellDidTapCell(_ cell: ImageViewTableViewCell, viewModel: Preview)
}

class ImageViewTableViewCell: UITableViewCell {
    
    static let identifier = "ImageViewTableViewCell"
    
    private var titles: [Title] = [Title]()
    
    private var randomIndex: Int = 0
    
    weak var delegate: ImageViewTableViewCellDelegate?

    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(heroImageView)
        setupTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageView.frame = contentView.bounds
    }
    
    public func passToImageView(with titles: [Title]) {
        self.titles = titles
        self.randomIndex = Int(arc4random_uniform(UInt32(titles.count)))
        let randomTitle = titles[self.randomIndex].poster_path!
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(randomTitle)") else { return }
        heroImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "heroImage"))
    }
    
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        heroImageView.isUserInteractionEnabled = true
        heroImageView.addGestureRecognizer(tapGesture)
    }

    @objc private func handleTap() {
        guard let titleName = self.titles[self.randomIndex].original_title ?? self.titles[self.randomIndex].original_name else { return }
        guard let titleOverview = self.titles[self.randomIndex].overview else { return }
        guard let posterPath = self.titles[self.randomIndex].poster_path  else { return }
        
        APICaller.shared.getMovie(query: titleName + " trailer") { [weak self] result in
            switch result {
            case.success(let videoElement):
                self?.delegate?.imageViewTableViewCellDidTapCell(self!, viewModel: Preview(title: titleName, youtubeView: videoElement, titleOverview: titleOverview, posterPath: posterPath))

                
            case.failure(let error):
                print(error)
            }
        }

    }

}

