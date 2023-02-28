//
//  FavoriteMoviesViewModel.swift
//  movieApp
//
//  Created by Ertürk Alan on 24.02.2023.
//

import Foundation

import RealmSwift

class FavoriteMoviesViewModel : FavoriteMoviesViewModelProtocol {
    
    private let realm = try! Realm()
    private var movieList: [Movie] = []
    
    var networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func updateTitle(movieName: String) {
        notify(.updateTitle(movieName))
    }
    
    func getFavMovies() {
       movieList = realm.objects(Movie.self).map { $0 as Movie }.filter({ movie in
            movie.isFavorite == true
        })
        notify(.showFavMovies(movieList))
    }
    

    var delegate: FavoriteMoviesViewModelDelegate?
    
  
    private func notify(_ output: FavoriteMoviesViewModelOutput) {
        delegate?.handleViewModelOutput(output)
    }
    
}
