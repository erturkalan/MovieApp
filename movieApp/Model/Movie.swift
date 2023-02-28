//
//  Movie.swift
//  movieApp
//
//  Created by Ertürk Alan on 14.02.2023.
//

import Foundation
import RealmSwift

@objcMembers
class Movie: Object, Decodable {
    dynamic var id: Int = 0
    dynamic var posterPath: String?
    dynamic var releaseDate: String?
    dynamic var overview: String?
    dynamic var title: String?
    dynamic var voteAverage: Double = 0.0
    dynamic var genreIds = List<Int>()
    dynamic var isFavorite: Bool = false
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate)
        overview = try container.decodeIfPresent(String.self, forKey: .overview)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        voteAverage = try container.decodeIfPresent(Double.self, forKey: .voteAverage) ?? 0.0
        
        let genreIdArray = try container.decodeIfPresent([Int].self, forKey: .genreIds) ?? [Int]()
        genreIds.append(objectsIn: genreIdArray)
    }
    
    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case overview, title, id
        case genreIds = "genre_ids"
        case voteAverage = "vote_average"
    }
}

struct MovieResponse: Decodable {
    let page: Int
    let results: [Movie]
    let total_pages: Int
    let total_results: Int
}
