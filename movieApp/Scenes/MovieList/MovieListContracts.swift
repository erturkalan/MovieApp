//
//  MovieListContracts.swift
//  movieApp
//
//  Created by Ertürk Alan on 14.02.2023.
//

import Foundation

protocol MovieListViewModelProtocol {
    var delegate: MovieListViewModelDelegate? {get set}
    func updateTitle()
    func load(pageNumber: Int)
    func searchMovie(searchText: String, pageNumber: Int)
    func getGenres()
}

enum MovieListViewModelOutput {
    case updateTitle(String)
    case setLoading(Bool)
    case showMovieList([Movie])
    case getGenres([Genre])
}

protocol MovieListViewModelDelegate: AnyObject {
    func handleViewModelOutput (_ output: MovieListViewModelOutput)
}
