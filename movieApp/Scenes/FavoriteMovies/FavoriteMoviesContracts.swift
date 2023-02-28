//
//  FavoriteMoviesContracts.swift
//  movieApp
//
//  Created by Ertürk Alan on 24.02.2023.
//

import Foundation

protocol FavoriteMoviesViewModelProtocol {
    var delegate: FavoriteMoviesViewModelDelegate? { get set }
    func updateTitle(movieName: String)
    func getFavMovies()
}

enum FavoriteMoviesViewModelOutput {
    case updateTitle(String)
    case showFavMovies([Movie])
}

protocol FavoriteMoviesViewModelDelegate: AnyObject {
    func handleViewModelOutput (_ output: FavoriteMoviesViewModelOutput)
}

