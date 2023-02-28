//
//  MovieDetailViewController.swift
//  movieApp
//
//  Created by Ertürk Alan on 17.02.2023.
//

import UIKit
import Kingfisher
import RealmSwift

class MovieDetailViewController: UIViewController {
    
    private let realm = try! Realm()
    
    //UI
    private let posterImageView = UIImageView()
    private let detailStackView = UIStackView()
    private let titleLabel = UILabel()
    private let voteLabel = UILabel()
    private let genreLabel = UILabel()
    private let favoriteButton = UIButton()
    private let overviewLabel = UITextView()
    private var castCollectionView: UICollectionView!
    
    private var genreNames: [String] = []
    private var castList: [Cast] = []
    private let movie: Movie
    
    //viewModel
    private let viewModel: MovieDetailViewModel
    
    
    
    init(viewModel: MovieDetailViewModel, movie: Movie) {
        self.movie = movie
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.updateTitle(movieName: movie.title ?? "")
        viewModel.getGenreNames(movie: movie)
        viewModel.getCast(movieId: movie.id)
        
        configurePosterImageView()
        configureDetailStackView()
        configureCollectionView()
        configureOverviewLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureMovie()
        favoriteButton.tintColor = movie.isFavorite ? .systemYellow : .systemGray2
    }
    
    private func configureMovie() {
        if let movieObject = realm.objects(Movie.self).first(where: { $0.id == self.movie.id }) {
            do {
                try realm.write {
                    self.movie.isFavorite = movieObject.isFavorite
                }
            } catch {
                
            }
        }
    }
    
    private func configurePosterImageView() {
        //fetch image for Image View with KingFisher Package
        if movie.posterPath != nil {
            let url = K.Api.imageUrl + movie.posterPath!
            posterImageView.fetchImage(from: url)
        }else{
            posterImageView.image = UIImage(named: "emptyMovie")
        }
        
        
        view.addSubview(posterImageView)
        
        posterImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, padding: Metrics.Padding.posterImageView,size: CGSize(width: (view.frame.width/2)-40, height: 280))
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.layer.cornerRadius = 10
        posterImageView.layer.masksToBounds = true
    }
    
    private func configureDetailStackView() {
        //Detail Stack View
        detailStackView.alignment = .top
        detailStackView.distribution = .fill
        detailStackView.axis = .vertical
        detailStackView.spacing = 16
        
        view.addSubview(detailStackView)
        
        detailStackView.anchor(top: posterImageView.topAnchor, left: posterImageView.rightAnchor, bottom: nil, right: view.rightAnchor, padding: Metrics.Padding.detailStackView)
        
        //configure Title Label
        titleLabel.text = movie.title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 0
        detailStackView.addArrangedSubview(titleLabel)
        
        //configure Vote Label
        voteLabel.text = String(movie.voteAverage) + " / 10"
        voteLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
        detailStackView.addArrangedSubview(voteLabel)
        
        //configure Genre Label
        genreLabel.text = genreNames.joined(separator: ",\n")
        genreLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
        genreLabel.numberOfLines = 0
        detailStackView.addArrangedSubview(genreLabel)
        
        //configure Favorite Button
        let tintedImage = UIImage(named: "star")?.withRenderingMode(.alwaysTemplate)
        favoriteButton.setImage(tintedImage, for: .normal)
        favoriteButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        favoriteButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        
        favoriteButton.addTarget(self, action: #selector(favoriteButtonPressed), for: .touchUpInside)
        detailStackView.addArrangedSubview(favoriteButton)
        
    }
    
    private func configureCollectionView() {
        castCollectionView = createCollectionView(scrollDirection: .horizontal, minLineSpacing: 10, minInteritemSpacing: 20, headerRefernceSizeHeight: 0, sectionInset: UIEdgeInsets(top: 4, left: 2, bottom: 4, right: 2), itemSize: CGSize(width: 60, height: 100))
        view.addSubview(castCollectionView)
        castCollectionView.anchor(top: posterImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, padding: Metrics.Padding.collectionView, size: CGSize(width: 0, height: 104))
        castCollectionView.register(CastCell.self, forCellWithReuseIdentifier: CastCell.reuseIdentifier)
        castCollectionView.backgroundColor = .white
        castCollectionView.delegate = self
        castCollectionView.dataSource = self
    }
    
    private func configureOverviewLabel() {
        overviewLabel.text = movie.overview
        overviewLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
        overviewLabel.textAlignment = .left
        view.addSubview(overviewLabel)
        
        overviewLabel.anchor(top: castCollectionView.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, padding: Metrics.Padding.overViewLabel)
    }
    
    //Favorite button pressed
    @objc func favoriteButtonPressed(sender: UIButton!) {
        do {
            try realm.write({
                if let movieObject = realm.objects(Movie.self).first(where: { $0.id == movie.id }) {
                    movieObject.isFavorite.toggle()
                    favoriteButton.tintColor = movieObject.isFavorite ? .systemYellow : .systemGray2
                } else {
                    movie.isFavorite.toggle()
                    favoriteButton.tintColor = movie.isFavorite ? .systemYellow : .systemGray2
                    realm.add(movie)
                }
            })
        } catch {
            print("Error \(error)")
        }
    }
                                
}

//MARK: - Movie Detail View Model Delegate Method
extension MovieDetailViewController: MovieDetailViewModelDelegate {
    
    func handleViewModelOutput(_ output: MovieDetailViewModelOutput) {
        switch output {
        case .updateTitle(let title):
            self.navigationItem.title = title
        case .getGenreNames(let names):
            self.genreNames = names
        case .showCast(let cast):
            self.castList = cast
            DispatchQueue.main.async {
                self.castCollectionView.reloadData()
            }
        }
    }
}
//MARK: - UICollectionView DataSource Method
extension MovieDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCell.reuseIdentifier, for: indexPath) as? CastCell else { return UICollectionViewCell() }
        
        let cast = castList[indexPath.row]
        cell.updateCell(cast)
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return castList.count
        
    }
    
}

extension MovieDetailViewController: UICollectionViewDelegate {
    
}

fileprivate struct Metrics {
    struct Padding {
        static let posterImageView: UIEdgeInsets = .init(top: 20, left: 20, bottom: 0, right: -10)
        static let detailStackView: UIEdgeInsets = .init(top: 12, left: 20, bottom: 0, right: -20)
        static let collectionView: UIEdgeInsets = .init(top: 20, left: 20, bottom: 0, right: -20)
        static let overViewLabel: UIEdgeInsets = .init(top: 20, left: 20, bottom: -20, right: -20)
    }
    
}


