//
//  MovieDetailViewModel.swift
//  movieApp
//
//  Created by Ertürk Alan on 17.02.2023.
//

import Foundation
import RealmSwift

class MovieDetailViewModel : MovieDetailViewModelProtocol {
    
    private var castList: [Cast] = []
    private var castResponse: CastResponse? {
        didSet{
            if let cast = castResponse?.cast {
            castList.append(contentsOf: cast)
            }
        }
    }
    
    private let realm = try! Realm()
    
    var networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func updateTitle(movieName: String) {
        notify(.updateTitle(movieName))
    }
    
    func getGenreNames(movie: Movie) {
        var names: [String] = []
        for id in movie.genreIds {
            for genre in realm.objects(Genre.self) {
                if id == genre.id {
                    names.append(genre.name)
                }
            }
         }
        notify(.getGenreNames(names))
               
    }
    
    func getCast(movieId: Int) {
        networkService.getCast(movieId: movieId) { result in
            self.castResponse = result
            self.notify(.showCast(self.castList))
        }
    }
    
    var delegate: MovieDetailViewModelDelegate?
    
  
    private func notify(_ output: MovieDetailViewModelOutput) {
        delegate?.handleViewModelOutput(output)
    }
    
}
