//
//  TitleCollectionViewCell.swift
//  Netflix
//
//  Created by Mohamed Ismail on 02/09/2023.
//

import UIKit
import SDWebImage

class TitleCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TitleCollectionViewCell"
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
    }
    
    public func passToTitleViewCell(with currentTitle: String) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(currentTitle)") else { return }
        posterImageView.sd_setImage(with: url, placeholderImage: nil)
    }
  
    
}
