//
//  FavoriteMoviesViewController.swift
//  movieApp
//
//  Created by Ertürk Alan on 17.02.2023.
//

import UIKit
import Kingfisher
import RealmSwift

class FavoriteMoviesViewController: UIViewController {
    
    
    private let realm = try! Realm()
    
    private var movieList: [Movie] = []
    private var pageNumber = 1
    
    // UI
    private var collectionView: UICollectionView!
    
    //viewModel
    private let viewModel: FavoriteMoviesViewModel
    
    init(viewModel: FavoriteMoviesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureCollectionView()
        viewModel.delegate = self
        viewModel.updateTitle(movieName: K.favoritePageName)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getFavMovies()
    }
    
    private func configureCollectionView() {
        collectionView = createCollectionView(minLineSpacing: 10, minInteritemSpacing: 10, headerRefernceSizeHeight: 10, sectionInset: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20), itemSize: CGSize(width: (view.frame.width / 2) - 40, height: 300))
        view.addSubview(collectionView)
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor , bottom: view.safeAreaLayoutGuide.bottomAnchor , right: view.rightAnchor, padding: Metrics.Padding.collectionView)
        collectionView.register(MovieListCell.self, forCellWithReuseIdentifier: MovieListCell.reuseIdentifier)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
}

extension FavoriteMoviesViewController: FavoriteMoviesViewModelDelegate {
    func handleViewModelOutput(_ output: FavoriteMoviesViewModelOutput) {
        switch output {
        case .updateTitle(let title):
            self.navigationItem.title = title
        case .showFavMovies(let movies):
            self.movieList = movies
            self.collectionView.reloadData()
        }
    }
    
    
}



//MARK: - UICollectionView DataSource and DelegateFlowLayout Methods
extension FavoriteMoviesViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieListCell.reuseIdentifier, for: indexPath) as? MovieListCell else { return UICollectionViewCell() }
        
        let movie = movieList[indexPath.row]
        cell.updateCell(movie)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == movieList.count - 1 {
            pageNumber += 1
            //viewModel.searchMovie(searchText: searchedTerm, pageNumber: pageNumber)
            
        }
    }
}

//MARK: - UICollectionView Delegate Method
extension FavoriteMoviesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        app.router.goToMovieDetail(from: self, movie: movieList[indexPath.row])
    }
}


fileprivate struct Metrics {
    struct Padding {
        static let searchBar: UIEdgeInsets = .init(top: 10, left: 10, bottom: -10, right: -10)
        static let collectionView: UIEdgeInsets = .init(top: 2, left: 6, bottom: -2, right: -6)
    }
    
    struct Size {
        static let searchBar: CGSize = .init(width: 0, height: 40)
    }
}
