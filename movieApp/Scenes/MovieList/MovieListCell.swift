//
//  MovieListCell.swift
//  movieApp
//
//  Created by Ertürk Alan on 15.02.2023.
//

import UIKit

class MovieListCell: UICollectionViewCell {
    
    static let reuseIdentifier = "MovieListCell"
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.layer.shadowRadius = 2
        imageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 0.7
        imageView.layer.masksToBounds = false
        
        setCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setCellUI() {
        //configure imageView
        contentView.addSubview(imageView)
        imageView.anchor(top: contentView.topAnchor, left: nil, bottom: nil, right: nil, size: CGSize(width: 160, height: 230))
        imageView.anchorWithCenter(centerX: contentView.centerXAnchor, centerY: nil)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true

        
        //configure title label
        contentView.addSubview(titleLabel)
        titleLabel.anchor(top: imageView.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, size: CGSize(width: 0, height: 50))
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
    }
    
    func updateCell(_ model: Movie){
        if model.posterPath != nil {
            let url = K.Api.imageUrl + model.posterPath!
            imageView.fetchImage(from: url)
        }else{
            imageView.image = UIImage(named: "emptyMovie")
        }
        titleLabel.text = model.title
    }
    
}
