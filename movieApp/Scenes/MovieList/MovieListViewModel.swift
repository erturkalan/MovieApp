//
//  MovieListViewModel.swift
//  movieApp
//
//  Created by Ertürk Alan on 14.02.2023.
//

import Foundation

final class MovieListViewModel: MovieListViewModelProtocol {
  
    private var movieList: [Movie] = []
    private var movieResponse: MovieResponse? {
        didSet{
            if let results = movieResponse?.results {
            movieList.append(contentsOf: results)
            }
        }
    }
    
    var delegate: MovieListViewModelDelegate?
    
    var networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func updateTitle() {
        notify(.updateTitle(K.appName))
    }
    
    func load(pageNumber: Int) {
        self.notify(.setLoading(true))
        networkService.fetchNowPlayingMovies(pageNumber: pageNumber) { result in
            self.notify(.setLoading(false))
            if pageNumber == 1 {
                self.movieList.removeAll()
            }
            self.movieResponse = result
            self.notify(.showMovieList(self.movieList))
        }
    }
    
    func searchMovie(searchText: String, pageNumber: Int) {
        self.notify(.setLoading(true))
        networkService.searchMovie(pageNumber: pageNumber, searchText: searchText ) { result in
            self.notify(.setLoading(false))
            if pageNumber == 1 {
                self.movieList.removeAll()
            }
            self.movieResponse = result
            self.notify(.showMovieList(self.movieList))
        }
    }
    
    func getGenres() {
        networkService.fetchGenres { result in
            self.notify(.getGenres(result.genres))
        }
    }
    
    private func notify(_ output: MovieListViewModelOutput) {
        delegate?.handleViewModelOutput(output)
    }
    
}
