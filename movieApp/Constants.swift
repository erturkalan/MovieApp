//
//  Constants.swift
//  movieApp
//
//  Created by Ertürk Alan on 18.02.2023.
//

import Foundation

struct K {
    static let appName = "MovieApp"
    static let favoritePageName = "Favorite Movies"
    struct Api {
        static let imageUrl = "https://image.tmdb.org/t/p/original"
        static let baseUrl = "https://api.themoviedb.org/3/movie/now_playing?api_key="
        static let apiKey = "b652ba7d6107fa05bee74f3d1943f48d"
        static let genreUrl = "https://api.themoviedb.org/3/genre/movie/list?api_key="
        static let searchUrl = "https://api.themoviedb.org/3/search/movie?api_key="
        static let castUrl = "https://api.themoviedb.org/3/movie/"
        static let languageUrlQuery = "&language=en-US"
    }
    struct Search {
        static let searchPlaceholder = "Search a movie"
    }
    
    
}

