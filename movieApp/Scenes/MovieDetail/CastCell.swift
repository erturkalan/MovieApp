//
//  CastCell.swift
//  movieApp
//
//  Created by Ertürk Alan on 19.02.2023.
//

import UIKit

class CastCell: UICollectionViewCell {
    
    static let reuseIdentifier = "CastCell"
    
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.shadowRadius = 2
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.2
        contentView.layer.masksToBounds = false
        
        setCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setCellUI() {
        //configure imageView
        contentView.addSubview(imageView)
        imageView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, size: CGSize(width: 0, height: 66))
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 6
        
        //configure title label
        contentView.addSubview(nameLabel)
        nameLabel.anchor(top: imageView.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, size: CGSize(width: 0, height: 30))
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.systemFont(ofSize: 8, weight: .regular)
    }
    
    func updateCell(_ model: Cast){
        if model.profilePath != nil {
            let url = K.Api.imageUrl + model.profilePath!
            imageView.fetchImage(from: url)
        }else{
            imageView.image = UIImage(named: "emptyAvatar")
        }
        nameLabel.text = model.name
    }
    
}

