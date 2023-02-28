//
//  MovieTabBarController.swift
//  movieApp
//
//  Created by Ertürk Alan on 14.02.2023.
//

import Foundation
import UIKit

class MovieTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
    }
    
    private func setupViewControllers() {
        //Movie List View Controller
        let movieListVM = MovieListViewModel(networkService: NetworkService.sharedInstance)
        let movieListVC = MovieListViewController(viewModel: movieListVM)
        movieListVC.tabBarItem = UITabBarItem(title: "Movies", image: UIImage(named: "movie"), tag: 0)
        movieListVC.tabBarItem.imageInsets = UIEdgeInsets(top: 114, left: 114, bottom: 114, right: 114)
        let movieListAppearance = UITabBarAppearance()
        movieListAppearance.stackedLayoutAppearance.selected.iconColor = .systemTeal
        movieListAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemTeal]

        movieListVC.tabBarItem.standardAppearance = movieListAppearance
        
        //Favorite Movies View Controller
        let favoriteMoviesVM = FavoriteMoviesViewModel(networkService: NetworkService.sharedInstance)
        let favoriteMoviesVC = FavoriteMoviesViewController(viewModel: favoriteMoviesVM)
        favoriteMoviesVC.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(named: "star"), tag: 1)
        favoriteMoviesVC.tabBarItem.imageInsets = UIEdgeInsets(top: 85, left: 85, bottom: 85, right: 85)
        let favoriteMoviesAppearance = UITabBarAppearance()
        favoriteMoviesAppearance.stackedLayoutAppearance.selected.iconColor = .systemYellow
        favoriteMoviesAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemYellow]
        favoriteMoviesVC.tabBarItem.standardAppearance = favoriteMoviesAppearance
        
        // Adding VC's to Navigation Controller
        let vc1 = UINavigationController(rootViewController: movieListVC)
        let vc2 = UINavigationController(rootViewController: favoriteMoviesVC)
        
        // Setting VC's to Tab Bar Controller
        setViewControllers([vc1,vc2], animated: true)
    }
}


