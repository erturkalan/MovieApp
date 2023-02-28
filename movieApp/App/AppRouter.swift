//
//  AppRouter.swift
//  movieApp
//
//  Created by Ertürk Alan on 14.02.2023.
//

import Foundation
import UIKit


final class AppRouter {

    func goToMovieDetail(from: UIViewController, movie: Movie) {
        let viewModel = MovieDetailViewModel(networkService: NetworkService.sharedInstance)
        let movieDetailVC = MovieDetailViewController(viewModel: viewModel, movie: movie)
        from.navigationController?.pushViewController(movieDetailVC, animated: true)
    }
    
}
