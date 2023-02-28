//
//  MovieDetailContracts.swift
//  movieApp
//
//  Created by Ertürk Alan on 17.02.2023.
//

import Foundation

protocol MovieDetailViewModelProtocol {
    var delegate: MovieDetailViewModelDelegate? { get set }
    func updateTitle(movieName: String)
    func getGenreNames(movie: Movie)
    func getCast(movieId: Int)
}

enum MovieDetailViewModelOutput {
    case updateTitle(String)
    case getGenreNames([String])
    case showCast([Cast])
}

protocol MovieDetailViewModelDelegate: AnyObject {
    func handleViewModelOutput (_ output: MovieDetailViewModelOutput)
}

