//
//  UIViewController.swift
//  movieApp
//
//  Created by Ertürk Alan on 17.02.2023.
//

import Foundation
import UIKit

extension UIViewController {
    
    func createCollectionView(scrollDirection: UICollectionView.ScrollDirection  = .vertical , minLineSpacing: CGFloat, minInteritemSpacing: CGFloat, headerRefernceSizeHeight: CGFloat, sectionInset: UIEdgeInsets? = nil, itemSize: CGSize? = nil) -> UICollectionView{
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = scrollDirection
        layout.minimumLineSpacing = minLineSpacing
        layout.minimumInteritemSpacing = minInteritemSpacing
        layout.headerReferenceSize.height = headerRefernceSizeHeight
        if sectionInset != nil {
            layout.sectionInset = sectionInset!
        }
        if itemSize != nil {
            layout.itemSize = itemSize!
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        return collectionView
    }
    
}
