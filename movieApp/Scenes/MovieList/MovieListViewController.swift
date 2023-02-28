//
//  MovieListViewController.swift
//  movieApp
//
//  Created by Ertürk Alan on 14.02.2023.
//

import UIKit
import Kingfisher
import RealmSwift

class MovieListViewController: UIViewController {
    
    private let realm = try! Realm()
    
    private var movieList: [Movie] = []
    private var isSearchable: Bool = true
    private var pageNumber = 1
    private var searchedTerm = ""
    
    // UI
    private let searchBar = UISearchBar()
    private var collectionView: UICollectionView!
    private let noResultView = UIView()
    private let noResultImageView = UIImageView()
 
    //viewModel
    private let viewModel: MovieListViewModel
    
    init(viewModel: MovieListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        searcBarConfigure()
        configureCollectionView()
        configureNoResultView()
        
        viewModel.delegate = self
        viewModel.updateTitle()
        viewModel.load(pageNumber: pageNumber)
        viewModel.getGenres()
    }
    
    private func configureCollectionView() {
        collectionView = createCollectionView(minLineSpacing: 10, minInteritemSpacing: 10, headerRefernceSizeHeight: 10, sectionInset: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20), itemSize: CGSize(width: (view.frame.width / 2) - 40, height: 300))
        view.addSubview(collectionView)
        collectionView.anchor(top: searchBar.bottomAnchor, left: view.leftAnchor , bottom: view.safeAreaLayoutGuide.bottomAnchor , right: view.rightAnchor, padding: Metrics.Padding.collectionView)
        collectionView.register(MovieListCell.self, forCellWithReuseIdentifier: MovieListCell.reuseIdentifier)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func searcBarConfigure() {
        view.addSubview(searchBar)
        searchBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, padding: Metrics.Padding.searchBar, size: Metrics.Size.searchBar)
        
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = K.Search.searchPlaceholder
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
    }
    
    private func configureNoResultView() {
        view.addSubview(noResultView)
        noResultView.anchor(top: searchBar.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
        noResultView.backgroundColor = .white
        
        noResultView.addSubview(noResultImageView)
        
        noResultImageView.anchorWithCenter(centerX: noResultView.centerXAnchor, centerY: noResultView.centerYAnchor, size: CGSize(width: 300, height: 350))
        
        noResultImageView.image = UIImage(named: "cantFind")
        noResultImageView.contentMode = .scaleAspectFit
        noResultView.isHidden = true
    }
}


//MARK: MovieListViewModel Delegate Methods

extension MovieListViewController: MovieListViewModelDelegate {
    
    func handleViewModelOutput(_ output: MovieListViewModelOutput) {
        switch output {
        case .updateTitle(let title):
            self.navigationItem.title = title
        case .setLoading(let isLoading):
            print(isLoading)
        case .showMovieList(let movies):
            if(movies.isEmpty) {
                noResultView.isHidden = false
            }else{
                noResultView.isHidden = true
            }
            self.movieList = movies
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                if self.pageNumber == 1  && !self.movieList.isEmpty{
                self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredVertically, animated: false)
                }
            }
        case .getGenres(let result):
            do {
                try realm.write({
                    for item in result {
                        if !realm.objects(Genre.self).contains(where: { genre in
                            item.id == genre.id
                        }) {
                            realm.add(item)
                        }
                    }
                })
            } catch {
                print("Error \(error)")
            }
            
        }
    }
}

//MARK: - UICollectionView DataSource and DelegateFlowLayout Methods
extension MovieListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
            if(isSearchable){
                viewModel.load(pageNumber: pageNumber)
            }else{
                viewModel.searchMovie(searchText: searchedTerm, pageNumber: pageNumber)
            }
        }
    }
}

//MARK: - UICollectionView Delegate Method
extension MovieListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        app.router.goToMovieDetail(from: self, movie: movieList[indexPath.row])
    }
}

//MARK: - UISearchBar Delegate Method
extension MovieListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
        if searchBar.text != "" {
            isSearchable = false
            pageNumber = 1
            if let title = searchBar.text {
                searchedTerm = title
                viewModel.searchMovie(searchText: title, pageNumber: pageNumber)
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let count = searchBar.text?.count {
            if count == 0 {
                isSearchable = true
                pageNumber = 1
                viewModel.load(pageNumber: pageNumber)
                DispatchQueue.main.async {
                    searchBar.resignFirstResponder()
                }
            }else if count >= 3 {
                isSearchable = false
                pageNumber = 1
                if let title = searchBar.text {
                    searchedTerm = title
                    viewModel.searchMovie(searchText: title, pageNumber: pageNumber)
                }
            }
        }
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
